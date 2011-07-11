Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab1GKNRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:17:32 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:58905 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886Ab1GKNRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:17:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwEALL3Gk5bdWOb/2dsb2JhbABTqDCIfL9UhVtfBKMd
X-IronPort-AV: E=Sophos;i="4.65,515,1304287200"; 
   d="scan'208";a="859050283"
Date: Mon, 11 Jul 2011 15:17:25 +0200
From: =?iso-8859-1?Q?V=EDctor_M=2E_J=E1quez_L=2E?= <vjaquez@igalia.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Jianbin Kang <kjbmail@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] kbuild: incremental tags updating with GNU GLOBAL
Message-ID: <20110711131725.GA26907@lit.local.igalia.com>
References: <1310379990-4367-1-git-send-email-vjaquez@igalia.com>
 <4E1AE9E2.2000603@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E1AE9E2.2000603@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 02:17:38PM +0200, Michal Marek wrote:
> On 11.7.2011 12:26, Víctor Manuel Jáquez Leal wrote:
> >Instead of generating the tag database each time the target is ran, is better
> >just update incrementally the database. It will expend less time.
> >
> >Signed-off-by: Víctor Manuel Jáquez Leal<vjaquez@igalia.com>
> >---
> >  scripts/tags.sh |    6 +++++-
> >  1 files changed, 5 insertions(+), 1 deletions(-)
> >
> >diff --git a/scripts/tags.sh b/scripts/tags.sh
> >index 75c5d24..6a2fedc 100755
> >--- a/scripts/tags.sh
> >+++ b/scripts/tags.sh
> >@@ -116,7 +116,11 @@ docscope()
> >
> >  dogtags()
> >  {
> >-	all_sources | gtags -f -
> >+	if global -p; then
> >+		global -u
> >+	else
> >+		all_sources | gtags -f -
> >+	fi
> 
> Will this handle new source files properly?

I ran a quick test and yes, it does.

vmjl
