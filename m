Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab1DOOEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:04:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35995 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab1DOOEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:04:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FqRCbGWcKWuV5x0m44Is08MTNqtE+ClKWPEaWxf3v27y5MGTxqGVXwoISXxjfBMUHg
         wxg3m/81KCGpUChKq6iANL11HGcblm7Mg1Fkl1w0a1ny1t4WwXyMIoWLxtxDoPHgSYL9
         CuAQWLfsTkkb88PHAq8fLKaXtrAhx0cmCQ8ZY=
Subject: Re: [PATCH 1/2] MTD: s3c2410_nand: Add option to disable hw ECC at
 runtime
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Holger Freyther <zecke@openmoko.org>
In-Reply-To: <4DA7094D.9070002@metafoo.de>
References: <1302637672-25339-1-git-send-email-lars@metafoo.de>
	 <1302782911.2796.21.camel@localhost>  <4DA7094D.9070002@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Apr 2011 17:01:11 +0300
Message-ID: <1302876071.3220.60.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-14 at 16:48 +0200, Lars-Peter Clausen wrote:
> On 04/14/2011 02:08 PM, Artem Bityutskiy wrote:
> > On Tue, 2011-04-12 at 21:47 +0200, Lars-Peter Clausen wrote:
> >> From: Holger Freyther <zecke@openmoko.org>
> >>
> >> This patch adds a flag to the s3c2410_nand platform data, which configures
> >> whether hardware ECC is used.
> >>
> >> Currently it is only possible to decide whether hw ECC should be used or not at
> >> compile time through a config option. But if you want to build a kernel which
> >> runs on multiple devices you might have a configuration where some devices
> >> require hw ECC and some devices which want software ECC.
> >>
> >> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> > 
> > Extending platform data is kind of vetoed in arm tree, I do not think
> > the MTD tree can take these changes.
> > 
> That is not my understanding of the situation. But what do you suggest as an
> alternative for fixing this issue?

Well, I got this understanding by talking to the OMAP maintainer and by
chatting with rmk. But I might be wrong. So the understanding is that
board data extending is banned, at least for a while. And the arm world
has to consolidate and probably switch to the DT tree approach. This
would be painful, this would make some vendors to return to behind the
curtains, so this would be a step back in the short run.

But in a couple of years this would be resolved, may be under Linaro's
aegis, and then the arm world would make 2 steps forward, so that
previous step back would be compensated in the longer run.

But! I'm just an small MTD guy, so I might be mistaken. Of course if you
make your board file changes be merged via the corresponding arm
sub-tree - go ahead send your MTD driver updates! This is I guess the
answer to your "what do you suggest" question.

CCing the arm lists so that people could correct me.

Here is the beginning of the thread:
http://lists.infradead.org/pipermail/linux-mtd/2011-April/034866.html

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

