Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab1GMD7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 23:59:01 -0400
Received: from nm1-vm0.bullet.mail.ird.yahoo.com ([77.238.189.95]:21821 "HELO
	nm1-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756585Ab1GMD67 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 23:58:59 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 474497.54836.bm@omp1020.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=CW+QgFCvdtVOQFnqOadQ8ZVvvA2mWOCe61+xcvnYEtQh0ZoBjA3mWjB4b3O+VHc02R7FevMsB79im6WVeWZMn/CUyGY9ZkcxMOS4FbL1U4x3AC5GbXZOIT/BE73DDNbkmB/cjqV+hVjXyOq1+01Ngd9ZVesl8AjGT1aEaH7msz0=;
X-YMail-OSG: 5P3PEDUVM1n0WtecaFkmILtbGZ9LgdIDVsSAhlHSCA_I6Z5
 _c_IR6iW7YWejM_BzdN.6E7u6Ajrn.uviRoWiShJiSjQ1NZQP6p9Nb8ER_LC
 3uNee46JkblkYeYZpxTMgCJmK7mUpEURar1Hb9ozxj9Eyebs3NzTmjLC._jE
 nZPXJx.QQqjq3UR6GflF6rCWP5SskQ6rE.p4p5Lis0PYValUluhR8OPB.wBz
 SITVjbk9C.2sWmUfMsVLktnkhASeGHojDu5zjz9lzIVMllHflrD_exvYGPDI
 Yjzu2xa6DIdUPXKWE_nLWrJqSN3EaMY_P_5Q8htp9aHeh89Paty3bnkxq4GM
 ZPqf_98teD16W85i9pQ--
X-Mailer: YahooMailClassic/14.0.3 YahooMailWebService/0.8.112.307740
Message-ID: <1310529537.96670.YahooMailClassic@web29502.mail.ird.yahoo.com>
Date: Wed, 13 Jul 2011 04:58:57 +0100 (BST)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: [PATCH] hfsplus: Add record offset check
To: linux-fsdevel@vger.kernel.org, Naohiro Aota <naota@elisp.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87mxgku044.fsf@elisp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 11/7/11, Naohiro Aota <naota@elisp.net> wrote:

> Recently I have general protection
> fault when I'm using hfsplus. This
> fault seems to be caused by "record offset" which is larger
> than "node
> size".

You have supposedly worked on this full time for 6 weeks under the google summer of code scheme... I am concerned that you have so far worked in isolation and not discuss your work with others, also you only mentioned a problem (the one on discussion here) only when I asked for a progress/status update.

So please
(1) explain the context of this problem - e.g. how did you corrupt the disk?
(2) explain your reasoning of *how* and *why* you choose to band-aid over this problem - considered that you have not yet found the cause, you want to band-aid over it; there are multiple ways of band-aiding over it, why did you choose this specific approach? and you need to include a discussion of possible bad-side effects, if any, of band-aiding over such a problem.
(3) explain your purpose of posting this patch to linux-kernel. You just posted it, saying there is a problem, there is a band-aid. In what way do you expect others to respond to your posting? As it is a band-aid, request for inclusion to standard kernel release is out, really.

I have looked over the updated commit log messages on the hfsplus kernel work on github yesterday. They are not good - you need to write more about your analysis and understanding of the netgear patch. In addition to that, you need to include a discussion of patch order and dependency in the commit message of either the first patch or the last of the series. Also, since one of the patches is about new "debug constants', that would mean there is new debug code, which means that should be separate and/or optional as well, but that's if and when you continue the devel work - you need to show that you understand what the patch does first, and that means describing them in the commit log messages, before you continue.

Unlike userland code, review on kernel changes are taken far more seriously; few people would bother trying out unknown-stranger's kernel change without looking at what it does first; especially changes that can destabilize a whole system (lock-up in a kernel module -> lock up the kernel), and especially changes that might involve data corruption/loss such as in the file system layer. So your suggested changes need to pass on-paper review first.

<snipped>
> Though this fault doesn't stop kernel entirely, it stop
> filesystem and
> suspend to work (because user process is blocked and so it
> cannot
> freeze any more), so it's really annoying.
> 
> From 5278a51f2a140efcc63119cc4226735f79c1fce4 Mon Sep 17
> 00:00:00 2001
> From: Naohiro Aota <naota@elisp.net>
> Date: Tue, 12 Jul 2011 02:54:13 +0900
> Subject: [PATCH] hfsplus: Add record offset check
> 
> Corrupted disk may return record offset which is larger
> than node size
> and cause general protection fault like below:

<snipped>

> This patch add guard for this situation.
> 
> Signed-off-by: Naohiro Aota <naota@elisp.net>

Nacked. This isn't acceptable. Explained above.

> ---
>  fs/hfsplus/brec.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/hfsplus/brec.c b/fs/hfsplus/brec.c
> index 2312de3..5c51d04 100644
> --- a/fs/hfsplus/brec.c
> +++ b/fs/hfsplus/brec.c
> @@ -43,6 +43,10 @@ u16 hfs_brec_keylen(struct hfs_bnode
> *node, u16 rec)
>             
> node->tree->node_size - (rec + 1) * 2);
>          if (!recoff)
>             
> return 0;
> +        if (recoff >=
> node->tree->node_size) {
> +           
> printk(KERN_ERR "hfs: recoff %d too large\n", recoff);
> +           
> return 0;
> +        }
>  
>          retval =
> hfs_bnode_read_u16(node, recoff) + 2;
>          if (retval >
> node->tree->max_key_len + 2) {
> -- 
> 1.7.6


