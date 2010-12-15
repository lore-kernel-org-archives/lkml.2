Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab0LOUbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 15:31:00 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:40618 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab0LOUa7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:30:59 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=H95gfW32JB/XYJSBuOTvJ8IIviFcsPdfxXHbM7LS6jM= c=1 sm=1
 a=btxqJe0AtA4A:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=xqWC_Br6kY4A:10
 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=6PDNlZEnZI99fjDDvPoA:9
 a=Ja57xwpizB5M5088PFUA:7 a=-6Siouj20s3T9aNFSevBXJohvXwA:4 a=CjuIK1q_8ugA:10
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH v2] fs: select: fix information leak to userspace
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <20101215094953.GG19804@ZenIV.linux.org.uk>
Date: Wed, 15 Dec 2010 13:30:56 -0700
Cc: P??draig Brady <P@draigBrady.com>,
        Am??rico Wang <xiyou.wangcong@gmail.com>, wharms@bfs.de,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>, kernel-janitors@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Jelinek <jakub@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <0BAF9CFC-72BF-49A1-93D3-BF60B892389B@dilger.ca>
References: <8D90F8B2-EA29-4EB9-9807-294CE0D5523B@dilger.ca> <20101114092533.GB5323@albatros> <20101114180643.593d19ac.akpm@linux-foundation.org> <1289848341.2607.125.camel@edumazet-laptop> <20101123140111.GA3816@hack> <4CEBD37E.5060107@bfs.de> <203E1F2A-2D04-4B7F-8D1B-9DC24522CB5E@dilger.ca> <4CECECA2.6070301@draigBrady.com> <20101124110535.GD5139@cr0.nay.redhat.com> <4CECFB19.1090003@draigBrady.com> <20101215094953.GG19804@ZenIV.linux.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-15, at 02:49, Al Viro wrote:
> Incorrect.  See 6.2.6.1 in C99; basically, padding bytes have unspecified
> contents.  Implementation is allowed to leave them in any state
> (including not bothering to copy them when doing struct assignments,
> etc.).  See Appendix J (portability issues) as well.
> 
> The bottom line: if you rely on that, you are relying on non-portable
> details of compiler behaviour.  Moreover, the authors are not even
> required to document what they are doing or to keep that behaviour
> consistent.

I thought my proposed solution was reasonable - add explicit padding fields where there are holes in the structure, which would be unused by the kernel, but since they are defined fields the compiler is obligated to initialize them.

This wouldn't add any overhead in cases where the compiler is already initializing the fields, and is still going to be less overhead than doing a memset(0) on the whole structure, and then initializing the other fields explicitly.

That has the added bonus that it becomes instantly clear where there are padding fields in the structure, and possibly they can be put to use in the future.

Cheers, Andreas





