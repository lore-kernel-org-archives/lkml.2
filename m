Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360Ab1IIQVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 12:21:45 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:40670 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759317Ab1IIQVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 12:21:44 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E6A3F09.5000307@cam.ac.uk>
Date: Fri, 09 Sep 2011 17:30:01 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110901 Thunderbird/6.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 1/2] regmap: Support half writes and padding between register
 and value.
References: <1315490964-25718-1-git-send-email-jic23@cam.ac.uk> <1315490964-25718-2-git-send-email-jic23@cam.ac.uk> <20110908162715.GB3098@opensource.wolfsonmicro.com> <4E69E019.6060601@cam.ac.uk> <20110909161418.GB3515@opensource.wolfsonmicro.com>
In-Reply-To: <20110909161418.GB3515@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/11 17:14, Mark Brown wrote:
> On Fri, Sep 09, 2011 at 10:44:57AM +0100, Jonathan Cameron wrote:
>> On 09/08/11 17:27, Mark Brown wrote:
> 
>>> Please do a patch adding padding separately - that does seem like a
>>> useful thing to have in general, with the option of having it both
>>> before and after the register.
> 
>> Happy to do it separately, but not sure the padding before the register
>> address is a real use case.  You pad after to give the device time to
>> respond, before doesn't make much sense to me on a register based device...
>> I'll change the naming to make it explicit that it is after the register though
>> so as to leave room for this to be added in future.
> 
> Some devices apparently use an entire byte or word with a magic flag in
> it to distinguish reads and writes.  These end up looking like 16 bit
> registers with only the lower 8 bits actually used in the current code.
Ah, fair enough there is a use case.  Can we add this as an additional patch
when needed?
