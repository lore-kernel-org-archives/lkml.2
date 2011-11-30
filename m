Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab1K3Hrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 02:47:49 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36770 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1K3Hrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 02:47:46 -0500
Date: Wed, 30 Nov 2011 07:47:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] trimming includes from linux/security.h
Message-ID: <20111130074745.GV2203@ZenIV.linux.org.uk>
References: <20111130065000.GT2203@ZenIV.linux.org.uk>
 <201111300709.pAU79PAs010669@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111300709.pAU79PAs010669@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 04:09:25PM +0900, Tetsuo Handa wrote:
> Al Viro wrote:
> > 	linux/security.h pulls a lot of garbage; most of it can be avoided
> > by several more struct ....; added in there,
> 
> Does it make sense to create a header file that contains only "struct ....;"
> lines? A lot of "struct ....;" lines are used for avoiding compiler warning.
> This results in LXR (linux cross reference) showing like
> 
> Defined as a struct type in:
> 
>     * security/selinux/include/avc.h, line 35

Er...  Then LXR sucks.  It's trivial to distinguish those from actual
definition; talks to LXR folks and let them fix their code...

struct <tag> ;

vs

struct <tag> {

is not that hard to handle, even if you bother with __attribute__ in weird
places like that.  They need to distinguish those from
	struct <tag> <ident>
etc., after all, so they do some amount of lookahead...
