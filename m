Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab2IIMMe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 08:12:34 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3480 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2IIMMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 08:12:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6829"; a="234558913"
From: "Yaniv Gardi" <ygardi@codeaurora.org>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-mmc@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1343208766-8046-1-git-send-email-ygardi@codeaurora.org> <1343208766-8046-2-git-send-email-ygardi@codeaurora.org> <201207261336.32018.arnd@arndb.de>
In-Reply-To: <201207261336.32018.arnd@arndb.de>
Subject: RE: [PATCH v8 1/2] block: ioctl support for sanitize in eMMC 4.5
Date: Sun, 9 Sep 2012 15:12:29 +0300
Message-ID: <002e01cd8e84$639f6470$2ade2d50$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHDzz8EDiUYimLl7qXSy42bw/d2KwJkNgeQAMqiqvmXe/NMwA==
Content-language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't quite understand everything that you meant in your mail, however I
will try to explain briefly:

SANITIZE replaces the need to issue REQ_SECURE as part of the REQ_DISCARD
request. In this way DISCARD request finishes much faster (order of
magnitude) and thus improves system performance. When the NVM content must
be erased, the user may use SANITIZE to erase all unmapped sectors. 

An example of usage is refurbished devices in which the carrier wants to
erase NVM content (since the user used only DISCARDs), in this case the a
SANITIZE operation will be triggered in the carrier labs from a dedicated
application through IOCTL that goes directly to the device. Note that no
change to the FS is required for such operation.

Hope that answers your comments.

Thanks,
Yaniv

QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation


= > -----Original Message-----
= > From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-
= > owner@vger.kernel.org] On Behalf Of Arnd Bergmann
= > Sent: Thursday, July 26, 2012 4:37 PM
= > To: Yaniv Gardi
= > Cc: linux-mmc@vger.kernel.org; linux-arm-msm@vger.kernel.org; open
= > list
= > Subject: Re: [PATCH v8 1/2] block: ioctl support for sanitize in eMMC
4.5
= > 
= > On Wednesday 25 July 2012, Yaniv Gardi wrote:
= > >
= > > Adding a new ioctl to support sanitize operation in eMMC cards version
= > > 4.5.
= > > The sanitize ioctl support helps performing this operation via user
= > > application.
= > >
= > > Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
= > >
= > 
= > Can you explain how you expect this to be called by a file system?
= > We've debated this in the past and concluded that we probably want to do
= > it at the same time as batched discard, but I don't see if the sanitize
= > request should be sent for each FITRIM or whether we should better have
= > a separate file system level ioctl. My feeling is that it would be more
useful
= > to call this feature through a file system level ioctl than through a
block
= > level ioctl, but I guess it makes sense to support both.
= > 
= > 	Arnd
= > 
= > --
= > To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
the
= > body of a message to majordomo@vger.kernel.org More majordomo info
= > at  http://vger.kernel.org/majordomo-info.html

