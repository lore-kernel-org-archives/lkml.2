Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab1IEPFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 11:05:45 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:54642 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab1IEPFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 11:05:43 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E64E736.3060706@cam.ac.uk>
Date: Mon, 05 Sep 2011 16:13:58 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110901 Thunderbird/6.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: regmap module_put usage.
References: <4E64C6B3.80105@cam.ac.uk> <20110905150040.GB3889@opensource.wolfsonmicro.com>
In-Reply-To: <20110905150040.GB3889@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/11 16:00, Mark Brown wrote:
> On Mon, Sep 05, 2011 at 01:55:15PM +0100, Jonathan Cameron wrote:
> 
>> Right now, calling regmap_exit() results in a module_put of the
>> regmap-spi module which never has a module_get and hence it's
>> module use count wraps around and all hell breaks loose?
> 
> Oh, that's a bit of bitrot from a last minute reorg.  I'll fix it.
> 
Thanks, I just scrapped the calls as any module will be dependent statically
on the relevant regmap-bus.c file anyway.
