Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab0KXAeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:34:04 -0500
Received: from bc.sympatico.ca ([209.226.175.184]:55478 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753347Ab0KXAeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:34:02 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJbn60xGHlyW/2dsb2JhbACianK+EIVLBIRa
Date: Tue, 23 Nov 2010 18:43:55 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: rostedt@goodmis.org, mingo@elte.hu, peterz@infradead.org, hpa@zytor.com,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] jump label: add enabled/disabled state to jump
	label key entries
Message-ID: <20101123234355.GA21549@Krystal>
References: <cover.1290546539.git.jbaron@redhat.com> <d03959060763fecdf2523a3f1353e1fc59f8f4a1.1290546539.git.jbaron@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <d03959060763fecdf2523a3f1353e1fc59f8f4a1.1290546539.git.jbaron@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 18:41:32 up 230 days,  9:31,  4 users,  load average: 0.07, 0.11,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
[...]
> +static void update_jump_label_module(struct module *mod)
> +{
> +	struct hlist_head *head;
> +	struct hlist_node *node, *node_next, *module_node, *module_node_next;
> +	struct jump_label_entry *e;
> +	struct jump_label_module_entry *e_module;
> +	struct jump_entry *iter;
> +	int i, count;
> +
> +	/* if the module doesn't have jump label entries, just return */
> +	if (!mod->num_jump_entries)
> +		return;
> +
> +	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
> +		head = &jump_label_table[i];
> +		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
> +			if (!e->enabled)
> +				continue;
> +			hlist_for_each_entry_safe(e_module, module_node,
> +						  module_node_next,
> +						  &(e->modules), hlist) {
> +				if (e_module->mod != mod)
> +					continue;

Ouch.

Could you iterate on the loaded/unloaded module jump labels and do hash
table lookups rather than doing this O(n^3) iteration ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
