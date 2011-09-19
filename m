Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab1ISQDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 12:03:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44135 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab1ISQDd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 12:03:33 -0400
Subject: Re: [PATCH 1/9] Remove parent field in cpuacct cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, xemul@parallels.com, paul@paulmenage.org,
        lizf@cn.fujitsu.com, daniel.lezcano@free.fr, mingo@elte.hu,
        jbottomley@parallels.com
Date: Mon, 19 Sep 2011 18:03:05 +0200
In-Reply-To: <1316030695-19826-2-git-send-email-glommer@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
	 <1316030695-19826-2-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316448186.1511.19.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-14 at 17:04 -0300, Glauber Costa wrote:
> +       for (; ca; ca = parent_ca(ca)) {

It might be good to check that the loop condition and null condition in
the parent_ca() function get folded. Otherwise there's a double branch
in that loop.

Note that this function is one of the reasons I dislike cpuacct, it adds
a second cgroup hierarchy traversal to every context switch.

Cache-miss heaven all this.
