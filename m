Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761489Ab2DMLGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 07:06:30 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:55464 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2DMLG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 07:06:29 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap1nAM0HiE9V5qnhPGdsb2JhbABFiiisEASBBBkBAQEBNzSCCQEBBAE6HCMFCwgDDjgUJQoaiBwJuW0Ti0mFGGMElWuGAoNViUk
X-IronPort-AV: E=Sophos;i="4.75,417,1330902000"; 
   d="scan'208";a="16099064"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 13 Apr 2012 13:09:04 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 11/16 v2] Input: atmel_mxt_ts - refactor reading object
 table
Message-ID: <20120413110904.GA4842@polaris.bitmath.org>
References: <1333039766-8617-1-git-send-email-djkurtz@chromium.org>
 <1333039766-8617-12-git-send-email-djkurtz@chromium.org>
 <20120413091147.GA3923@polaris.bitmath.org>
 <CAGS+omD5WxL4mrt8Czw7M3OAbuBH2CVO-EmFmhG3VucSNRuLCw@mail.gmail.com>
 <20120413093446.GA4218@polaris.bitmath.org>
 <CAGS+omCMWqWsALjBd=r5HbKMQ+ZJKayuUEQuL7LXwkbr+xmy1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGS+omCMWqWsALjBd=r5HbKMQ+ZJKayuUEQuL7LXwkbr+xmy1g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I am talking about the data that is being read here and written in
> > mxt_check_reg_init(). By matching the struct with that data, all the
> > copies you make would go away.
> 
> The data read here is a table of object descriptors.  The data written
> in mxt_check_reg_init() is configuration data for each of the objects
> described by the descriptors.  What copies are you talking about?

In this patch, the object descriptors are read into a buffer, then
copied over to the object struct that you hold. That is the copy that
obviously goes away if the data is copied directly into the suggested
struct. In patch 9, you copy an unknown amount of data over to a
stack-allocated buffer before sending it via ic2. That is the main
technichal concern, and it was the first question you got, some days
ago.

> The config array in platform_data is a single big long array that has
> to be manually created in a platform file.  It just has blobs of data
> for each of the 'writable' objects for a given device, all
> concatenated together.

Ok, so no need for the second suggested struct or anything of that
kind. Just sort out the maximum blob size and, if necessary, avoid the
stack allocation in mxt_check_reg_init(), and it should be fine.

Henrik
