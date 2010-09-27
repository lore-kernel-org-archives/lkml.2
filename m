Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851Ab0I0ITm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 04:19:42 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59717 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab0I0ITl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 04:19:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ehcgksstEySmsKJ85kv712XDZnEgeN1iVSjMai8zdd1eG84FR4MpGGyyrw1FK/RCVw
         v2VR/z/kXetK4IthboTmrH/HAvjAxICM2G2HEWASLMnJK+pv/+lPSwQMxxDjcC73ecty
         WwEewaASm60CpYdNIbTMLWLRZ6ZewRPCjHpHY=
Date: Mon, 27 Sep 2010 16:24:11 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: matt mooney <mfm@muteddisk.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] kbuild: remove duplicate -I flag in addtree
Message-ID: <20100927082411.GD5785@cr0.nay.redhat.com>
References: <1285553472-924-1-git-send-email-mfm@muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285553472-924-1-git-send-email-mfm@muteddisk.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 07:11:12PM -0700, matt mooney wrote:
>When O= is used, any -I flag given that is not an absolute path gets
>duplicated. The $(1) appended to the conditional clause covers the
>absolute case, but due to being outside of the conditional statement
>it gets added everytime.
>
>Signed-off-by: matt mooney <mfm@muteddisk.com>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

>---
> scripts/Kbuild.include |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
>index ed2773e..08c74ed 100644
>--- a/scripts/Kbuild.include
>+++ b/scripts/Kbuild.include
>@@ -158,7 +158,7 @@ modbuiltin := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.modbuiltin obj
> # Prefix -I with $(srctree) if it is not an absolute path.
> # skip if -I has no parameter
> addtree = $(if $(patsubst -I%,%,$(1)), \
>-$(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1))) $(1))
>+$(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1)),$(1)))
> 
> # Find all -I options and call addtree
> flags = $(foreach o,$($(1)),$(if $(filter -I%,$(o)),$(call addtree,$(o)),$(o)))


The original code also missed a comma, this patch fixes it.

Thanks!
