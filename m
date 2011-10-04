Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab1JDOwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 10:52:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62671 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab1JDOwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 10:52:08 -0400
Date: Tue, 4 Oct 2011 16:51:56 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: UDF: alternate anchor block detection
Message-ID: <20111004145156.GA4183@joi.lan>
References: <CADDb1s3Ab18ppaDKeRYMnX9TSb_kHaj4T1wUA=FeNUjpxF2cRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADDb1s3Ab18ppaDKeRYMnX9TSb_kHaj4T1wUA=FeNUjpxF2cRw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 05:16:15PM +0530, Amit Sahrawat wrote:
> While mounting UDF media, when the primary AVDP is not found at block
> 256, UDF code tries to read-in the alternate AVDP.
> In the function udf_find_anchor, udf_scan_anchors is called 3 times,
> where each call to udf_scan_anchors read 12 blocks.
> In case there is no alternate AVDP stored, a total of 36 blocks are
> read before mount fails - causing time delay for Mount Failure.
> 
> 1) After first call to udf_scan_anchors and before the second call
> there is varconv conversion, for the older drivers, which skips 7
> blocks after every 32 blocks. What are these older drivers? Do we
> still require this code?

I'm not sure what "drivers" are you talking about, but "UDF_SET_FLAG(sb,
UDF_FLAG_VARCONV)" does not convert anything - it just sets superblock
flag.

> 2) After varconv conversion, why is there a third call to
> udf_scan_anchors? In the 1st call and 3rd call to udf_scan_anchors,
> exactly same blocks are read, so this 3rd call seems to be redundant.

Because UDF_FLAG_VARCONV changes behavior of udf_scan_anchors.

Marcin
