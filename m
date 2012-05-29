Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab2E2R4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 13:56:47 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45327 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab2E2R4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 13:56:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5iQr9Q3=94DBkUPNKTWS3F0SNKyBgrpCATWgtLeJ-98g@mail.gmail.com>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
	<1337754877-19759-3-git-send-email-yinghai@kernel.org>
	<CA+55aFzd1BWqidt95qZLc1x_YU=WeGS=mKUOMvO_3omOhc_5VA@mail.gmail.com>
	<CAE9FiQXx_x9M5ncLk4DyL8heYQTcsHZt2JofFMjPfUd4mympeA@mail.gmail.com>
	<CAE9FiQX=ECg5BmKm7B2ua_rZ6bOsceeHNsfFQRWBbNZx+8sBfw@mail.gmail.com>
	<20120525043651.GA1391@google.com>
	<CAE9FiQXvYH4zCqp_uOb2nw7jvm8B=q3yx1tCjJUT+PkdymYEuw@mail.gmail.com>
	<CAE9FiQW0rm2_sKdSCWs3TfatJB9yHwvmvt9_vBYMtOq_YBbmfw@mail.gmail.com>
	<20120525193716.GA8817@google.com>
	<CAE9FiQWrZaBpT1fzC_-mSBfDd4AKGrdGomPxVNSU-SFPrVNvOw@mail.gmail.com>
	<CAErSpo7d+zn-qgWKcbro7yneXRtmZQCOHi+kiGzYUTfs+aiF4g@mail.gmail.com>
	<CAE9FiQUWWO75WP3gYRwYbyO_ZiWwyjKnzMxOGhfjY4H98w2Hbw@mail.gmail.com>
	<CAErSpo46fCCFCijNfMzGYP__pP6hkPFurMS=1=wSAZsg5z0-Lg@mail.gmail.com>
	<CAErSpo5iQr9Q3=94DBkUPNKTWS3F0SNKyBgrpCATWgtLeJ-98g@mail.gmail.com>
Date: Tue, 29 May 2012 10:56:45 -0700
X-Google-Sender-Auth: ARcY7ZdJ9casMqp2yTNnM7f7WIc
Message-ID: <CAE9FiQWnQyiUdTkuinqsv05auaBsRhQvjZkBsYM8_gLN6ZVtQQ@mail.gmail.com>
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Newbury <steve@snewbury.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2012 at 8:01 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> Another bug here: we're trying to restrict the *bus* addresses we
> allocate, but we're applying the limits to *CPU* addresses.
> Therefore, this only works as intended when CPU addresses are the same
> as bus addresses, i.e., when the host bridge applies no address
> translation.  That happens to be the case for x86, but is not the case
> in general.
>
> I think we need a third patch to fix this problem.

yes.
