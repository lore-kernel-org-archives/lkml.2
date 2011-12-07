Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab1LGS1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:27:32 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53087 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab1LGS1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:27:31 -0500
Date: Wed, 7 Dec 2011 10:27:26 -0800
From: Tejun Heo <tj@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v2
Message-ID: <20111207182720.GB7610@google.com>
References: <20111206181026.GO29781@moon>
 <20111206143313.ac2e7287.akpm@linux-foundation.org>
 <20111206223558.GQ29781@moon>
 <20111207094144.GB21678@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207094144.GB21678@moon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 07, 2011 at 01:41:44PM +0400, Cyrill Gorcunov wrote:
> +static void children_seq_stop(struct seq_file *seq, void *v)
> +{
> +	rcu_read_unlock();
> +	seq_printf(seq, "\n");
> +}

Wouldn't this add newline on page boundary?  Newline should be printed
at the end of the whole sequence but seq_stop() is called at buffer
boundaries.

Thanks.

-- 
tejun
