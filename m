Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1CPUYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:24:25 -0400
Received: from mtxmxout5.matrox.com ([138.11.2.95]:34839 "EHLO
	mtxmxout5.matrox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab1CPUYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:24:19 -0400
X-Greylist: delayed 1566 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Mar 2011 16:24:19 EDT
X-Virus-MTX-Scanned: by Matrox Virus scanner at venus.matrox.com
Message-ID: <4D811651.6020607@matrox.com>
Date: Wed, 16 Mar 2011 15:58:09 -0400
From: Yannick Heneault <yannick_heneault@matrox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Gary Hade <garyhade@us.ibm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>, djwong@us.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Helt <krzysztof.h1@wp.pl>,
        Petr Vandrovec <vandrove@vc.cvut.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] matroxfb: remove incorrect Matrox G200eV support
References: <20110301175026.GA18770@us.ibm.com> <AANLkTikwSXN8VgDaoUqfHcxoTNxW9uA4D2fUtRLuLbHo@mail.gmail.com> <20110304202905.GB27190@tux1.beaverton.ibm.com> <1299488356.9759.2.camel@pasglop> <20110311222337.GC7614@us.ibm.com>
In-Reply-To: <20110311222337.GC7614@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It impossible that this patch should have work on a system. The patch 
only declare the G200eV as a regular G200 which is not case. Many 
registers are different, including at least the PLL programming 
sequence. If the G200eV is programmed like a regular G200, it will not 
display anything.

Yannick

On 03/11/2011 05:23 PM, Gary Hade wrote:
> On Mon, Mar 07, 2011 at 07:59:16PM +1100, Benjamin Herrenschmidt wrote:
>    
>> On Fri, 2011-03-04 at 12:29 -0800, Darrick J. Wong wrote:
>>      
>>> This is all quite strange -- 2.5 years ago when I wrote the patch it
>>> seemed to
>>> work ok.  On newer revisions of the x3650M2 it seems broken.  The
>>> original
>>> machine I wrote it for was cut up ages ago.
>>>
>>> I suppose we could simply blacklist any G200eV with a subsystem vendor
>>> ID of
>>> 0x1014 (IBM) until we figure out how to correct the driver.  Our
>>> customers will
>>> be deprived, but as it seems to be broken across most of our product
>>> lines I
>>> doubt any of them are making serious use of it anyway. :)
>>>
>>> Something like this?
>>>        
>> Does X work with the open source drivers ?
>>      
> Yes, X works fine on at least the IBM System x boxes that have
> the Matrox G200eV.
>
>    
>> In that case a better
>> approach would be to try to figure out what's different between the way
>> the 2 drivers setup the card registers and fix matroxfb..
>>      
> I suppose someone could attempt this but with vesafb available as
> an alternate fb provider and no known demand for repaired G200eV
> support in matroxfb, I am not sure what benefit it would provide.
>
> Gary
>
>
>    

