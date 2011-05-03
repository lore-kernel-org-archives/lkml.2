Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab1ECRrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:47:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33274 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753396Ab1ECRrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:47:12 -0400
Date: Tue, 3 May 2011 18:47:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 1/2] regulator: Put mutex lock down to
 mc13783_powermisc_rmw function
Message-ID: <20110503174710.GH1762@opensource.wolfsonmicro.com>
References: <1304440830.16287.10.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304440830.16287.10.camel@phoenix>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 12:40:30AM +0800, Axel Lin wrote:
> mc13783_powermisc_rmw function is doing read/modify/write bitmask operations,
> thus add the lock to protect it.
> Then we can remove the lock/unlock from the caller.

This should be squashed in with the MFD patch I think otherwise we'll
get bisection points with either no lock or double locking (which upsets
lockdep IIRC).  The change itself looks good, though, and similarly for
patch 2
