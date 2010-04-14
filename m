Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0DNJlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 05:41:50 -0400
Received: from smtp108.sbc.mail.gq1.yahoo.com ([67.195.14.111]:30188 "HELO
	smtp108.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754750Ab0DNJlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 05:41:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jpAb6f1+ebu3UHKDPQ4319dcQa0W1SNC6nnRY46P26qdMoyPabu0tq/pHxmR66kOfMVjRVPGJ8QrIg8Kfj+85pgRzmnADleLcjMheMBnuWHkU3Q7o6ZpRymi5iotOPKTGNBpbyUQWkDGV0+gH2xKGAwkG3nF/HvrKErSE/5OPGw=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: ePlcA64VM1kwZ13ikxZe1nE1LFoRB0PR7kLOLI2SHIToFh_q.u2AoFc4YuHss_jBJRmZfZneTB6hBoDP0UP1IIQFgL875th6XxmWFCf7MclGsP2GyMHCVB9.2sPf44QOnq9OFknHHNwIZSBKG5FtEhv57v_.kJwp.lIyUVdepaahaRhQ8SrE7Ll8y.LsYI5nubXjMhTIK3viKZQr.49N3M204VBnG7OPQF9mQxl7gbWEuXebVzj8UAxj_q.6LCJivh0fX_o8Qz37ZCllGiZtpEPKHc.BD4UvmnB_JsLHBVeUqJiNJG39RwEhvpLbIgCzYLZDCCqU8SwAyq42wxAOMWfMJWibIYsrjSOT.ZCPEdyuMteFySj_ZB8-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 7/8] USB: testusb: imported David Brownell's USB testing application
Date: Wed, 14 Apr 2010 02:41:47 -0700
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, Peter Korsgaard <jacmet@sunsite.dk>,
       Rupesh Gujare <rupeshgujare@gmail.com>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
References: <cover.1270644740.git.mina86@mina86.com> <15d6fb76583235c380569d11d904cc0e8d019067.1270644740.git.mina86@mina86.com>  <3c4f11cdfb08952e964879c343d6ed7ceedc9542.1270644740.git.mina86@mina86.com>
In-Reply-To: <3c4f11cdfb08952e964879c343d6ed7ceedc9542.1270644740.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004140241.47445.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 April 2010, Michal Nazarewicz wrote:
> 
> The testusb application can be used to test various USB gadget
> that implment the source/sink intrerface.

That comment is woefully incomplete.  It's not just gadgets it exercises,
and a lot of thought went into testing streaming modes too (within limitations
of a the trivial test harness).

And more significantly ... It's part of a fairly complete test suite which exercises

- all four types of USB 2.0 data transfer,

          on both peripheral and host sides

       - - Good coverage of observed hardware and software failure modes,
           (to help ensure routine fauilts are handled well)

    -  Decent coverage of Linux-USB programmming interfaces ... both
       in-kernel and user-visible.

   - - Stress test modes

For more info, whvih *SHOULD* be referenced from wherever the
kernel tree includes any of this code:

See: http://www.linux-usb.org/usbtest/

Just throwing tools at someone without instructions can be rather
counter-productive .... they get misused, important issues ignored,
results mis-interpreteed, etc.

Note that there's a basic test plan, letting folk put
drivers (and hardware) through their paces.  THe evidence is that when
drivers behave on that whole suite, Linux won't misbehave much at all.

In fact, without such tools and a test plan, it'd be hard to have mch faith
in the drivr quality ... except as a weak and scattershot "this combination of
drivers and hardware seems OK for now".
futile


At one point there were allegedly folk working on Linux testng frameworks, but
they never seem to have looked at this (even on specific request); I'm not sure
if it was just general weakness in driver testing efforts (they're not easy to test),
lack of background (/interest?) in USB, or something else.   (As many of us know, it's
a sad truth that testing isn't all that glamorous, for all that it's essential).
