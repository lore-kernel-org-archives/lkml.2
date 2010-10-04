Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab0JDSxC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:53:02 -0400
Received: from graze.net ([71.162.143.10]:33524 "HELO graze.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755543Ab0JDSxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:53:01 -0400
X-Greylist: delayed 762 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Oct 2010 14:53:00 EDT
Date: Mon, 4 Oct 2010 14:39:36 -0400
From: "Brian C. Huffman" <bhuffman@graze.net>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Message-ID: <4CAA1F68.4080402@graze.net>
In-Reply-To: <20100924142924.cf074205.akpm@linux-foundation.org>
References: <4C759125.8030008@graze.net>
References: <20100924142924.cf074205.akpm@linux-foundation.org>
Subject: Re: Intel DP43BF MB - No PCI Devices detected
x-scalix-Hops: 1
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/24/2010 05:29 PM, Andrew Morton wrote:
> On Wed, 25 Aug 2010 17:54:45 -0400
> "Brian C. Huffman"<bhuffman@graze.net>  wrote:
>
>>    I have searched and found no previous posts on this topic.  Using the
>> 2.6.36-rc2-git3 (and many before that rev), the kernel doesn't see my
>> PCI devices.  They can be seen with dmidecode but do not show up with
>> lspci (and are not mentioned on boot up).
> Is this still happening?
>
> Do you know when it started happening?  Was 2.6.35 OK?  2.6.34?
>
Thanks.

Unfortunately I no longer have this board to help test.  I posted the 
same message on the linux-pci list and we got so far as to determine 
that somehow the kernel is getting the wrong primary / secondary bus 
number.  Using pci=assign-busses worked around it, but even after 
recognizing the cards, they didn't work properly and I had to send the 
board back.  Here's the pertinent excerpt from linux-pci:

On 09/10/2010 02:38 PM, Bjorn Helgaas wrote:
>
>> pci 0000:00:1e.0: PCI bridge to [bus 20-08] (subtractive decode)
> There's something wrong here because the [20-08] bus number range is
> backwards.  Maybe the secondary bus is really 08, but we scan bus 20
> instead?
>
> The "pci=assign-busses" parameter might work around this for now.
> Maybe Windows is smart enough to notice this problem and reprogram
> the bridge to something sensible automatically.
