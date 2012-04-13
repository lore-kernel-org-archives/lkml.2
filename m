Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab2DMJcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 05:32:12 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:49685 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026Ab2DMJcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 05:32:10 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApxnAKrxh09V5qnhPGdsb2JhbABFiiisQwSBBBkBAQEBNzSCCQEBBAE6HCMQCAMOOBQlChqIHAm5bhOLSYUYYwSVa4YCg1WJSQ
X-IronPort-AV: E=Sophos;i="4.75,416,1330902000"; 
   d="scan'208";a="312664180"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 13 Apr 2012 11:34:46 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 11/16 v2] Input: atmel_mxt_ts - refactor reading object
 table
Message-ID: <20120413093446.GA4218@polaris.bitmath.org>
References: <1333039766-8617-1-git-send-email-djkurtz@chromium.org>
 <1333039766-8617-12-git-send-email-djkurtz@chromium.org>
 <20120413091147.GA3923@polaris.bitmath.org>
 <CAGS+omD5WxL4mrt8Czw7M3OAbuBH2CVO-EmFmhG3VucSNRuLCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGS+omD5WxL4mrt8Czw7M3OAbuBH2CVO-EmFmhG3VucSNRuLCw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Putting this conversion in a function would be nice, it would also
> > make it clear that the inverse, used for writing, is currently
> > missing. Alternatively, how about making the object struct actually
> > match the read data? To top it off, one could introduce a collection,
> > prepending the buffer size, making the write operation trivial.
> 
> AFAIK, there is no corresponding "object table" write. The "object
> table" (maybe more aptly named the "object descriptor table") is an
> immutable blob read from firmware that describes some actual data
> objects elsewhere in device memory.  It is those actual objects that
> are writable.  When they are written, it is the actual size, location
> and number of instances (not their raw '-1' values) that is useful.

I am talking about the data that is being read here and written in
mxt_check_reg_init(). By matching the struct with that data, all the
copies you make would go away.

Henrik
