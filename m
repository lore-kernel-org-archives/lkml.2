Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab1IEP2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 11:28:18 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:48821 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab1IEP2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 11:28:15 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E64EC7C.5010005@cam.ac.uk>
Date: Mon, 05 Sep 2011 16:36:28 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110901 Thunderbird/6.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regmap bulk read styles.
References: <4E64E16A.6060401@cam.ac.uk> <20110905151917.GD3889@opensource.wolfsonmicro.com>
In-Reply-To: <20110905151917.GD3889@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/11 16:19, Mark Brown wrote:
> On Mon, Sep 05, 2011 at 03:49:14PM +0100, Jonathan Cameron wrote:
> 
>> The burst read is pretty much what you have covered by
>> regmap_bulk_read. I assume an implementation for spi
>> doing
> 
>> TX Addr1 XXXXX XXXXX XXXXX XXXXX
>> RX XXXXX Data1 Data2 Data3 Data4 ...
> 
>> would be general enough to be worth providing? Any device
>> that doesn't understand this should simply not use it.
> 
> Yes, that's the assumption the code is making for all buses.
Cool. If no one else does it in the meantime I'll add that one.
> 
>> The second is more interesting.  It actually looks quite like
>> your gather write.  We have a set of registers that we need
>> to read.  A classic example is that a coherent set will only
>> be received (e.g. valid at an instant in time) if we read
>> all channels of an accelerometer in one go (between chip selects).
> 
>> Would you be in favour of an interface to handle this use case
>> or is it better just to bypass regmap for this use case?
>> (which would be a pity as it leads to duplication as all the
>> configuration stuff fits nicely).
> 
> If you can come up with a tasteful interface for doing this I wouldn't
> object but my suspicion is that it's going to be easier to reimplement.
> It does seem useful, I'm just worried about how the interface would
> look.
I'll have a think at some point and get back to you.
> 
>> As an aside, isn't your gather write more typically described
>> as a scatter write?  (writes one coherent set to a number of
>> disjoint locations?)
> 
> On the write side it's generally a gather (reading from different
> locations and writing out a continuous stream) while on the read side
> it's generally a scatter (reading a continuous data stream and writing
> it to multiple locations).  The gather here refers to getting data from
> more than one place and using it to transmit a single byte stream.
> 

