Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab2GPXaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 19:30:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24671 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab2GPXaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 19:30:19 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-95-5004a4091c8c
Message-id: <5004A409.9000002@samsung.com>
Date: Tue, 17 Jul 2012 08:30:17 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: MAX77693: Fix bug of interrupt handlding for MAX77693
 devices
References: <1342431665-2812-1-git-send-email-cw00.choi@samsung.com>
 <20120716133636.GA22600@sirena.org.uk>
In-reply-to: <20120716133636.GA22600@sirena.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t9jQV2uJSwBBvcOsFhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M5n29bAVLWCuaOyIbGJewdDFyckgImEgc+feSDcIWk7hwbz2Y
	LSQwnVHie5dXFyMXkN3FJHH2Wj8jSIJXQEvidddCsGYWAVWJiXs3sYPYbEDx/S9uADVzcIgK
	REj86ueAKBeU+DH5HgtIWARo1+/7lSBhZoE8iaf7DoKtEhaIlPgws50JYm2uxMyOLrBNnALG
	ElfPQZzJLKAjsb91GhuELS+xec1b5gmMArOQbJiFpGwWkrIFjMyrGEVTC5ILipPScw31ihNz
	i0vz0vWS83M3MYJD75nUDsaVDRaHGAU4GJV4eAvKWQKEWBPLiitzDzFKcDArifBOnwUU4k1J
	rKxKLcqPLyrNSS0+xCjNwaIkzmvs/dVfSCA9sSQ1OzW1ILUIJsvEwSnVwKintm+9XW27go1a
	wmP3xPS7GjcTGm4WJxVzB80v/fY12OKhbcLEzBdd19ofbQ595327zVMu1HLz9aBeE4P92SIs
	+itZ74RLBXiGiWTs+RkU/cKzmclDffPkiwff73ZkdbYNvHbEP8b/1PH7MXoXEo4IeVZsevR8
	bqDaanuds+uaIu+l/I/mU2Ipzkg01GIuKk4EANDfxGE5AgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 10:36 PM, Mark Brown wrote:

> On Mon, Jul 16, 2012 at 06:41:05PM +0900, Chanwoo Choi wrote:
>> This patch fix bug related to interrupt handling for MAX77693 devices.
>> - Unmask interrupt masking bit for charger/flash/muic to revolve
>> that interrupt isn't happened when external connector is attached.
> 
> Shouldn't this be happening when the IRQ is requested?
> 


The interrupt isn't happened when external connector is attached
because muic interrupt of MAX77693 is masked on INTSRC_MASK(
Interrupt Source Mask) register. So, I should set zero to muic interrupt
masking bit of INTSRC_MASK before requesting IRQ.

Thank you,
Chanwoo Choi
