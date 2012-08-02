Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab2HBPVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 11:21:03 -0400
Received: from mso.anu.edu.au ([150.203.89.32]:42753 "EHLO mso.anu.edu.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab2HBPU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 11:20:59 -0400
X-Greylist: delayed 876 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Aug 2012 11:20:59 EDT
Message-ID: <501A955D.6030500@mso.anu.edu.au>
Date: Fri, 03 Aug 2012 00:57:33 +1000
From: Francois Rigaut <frigaut@mso.anu.edu.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, bhelgaas@google.com
Subject: Re: [PATCH V2 1/4] EFI: Stash ROMs if they're not in the PCI BAR
References: <1343407934-459-1-git-send-email-mjg@redhat.com> <20120731223240.GD19134@kroah.com> <20120801165400.GA3042@srcf.ucam.org> <20120801232147.GA6228@kroah.com> <20120802040242.GB25933@thinkpad-t410> <20120802103423.GA1921@kroah.com>
In-Reply-To: <20120802103423.GA1921@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, Seth,

Here is what the message.log shows:

switching to the HD4000 (integrated):

Aug  3 00:49:55 poliahu.ctio.noao.edu WindowServer[79]: Received display connect changed for display 0x42803c0
Aug  3 00:49:55 poliahu.ctio.noao.edu WindowServer[79]: CGXMuxAcknowledge: Posting glitchless acknowledge
Aug  3 00:49:55 poliahu.ctio.noao.edu WindowServer[79]: MPAccessSurfaceForDisplayDevice: Set up page flip mode on display 0x042803c0 device: 0x10c678320  isBackBuffered: 0 numComp: 1 numDisp: 3
Aug  3 00:49:55 poliahu.ctio.noao.edu WindowServer[79]: Received display connect changed for display 0x42803c0
Aug  3 00:49:55 poliahu.ctio.noao.edu WindowServer[79]: Received display connect changed for display 0x3f003d
Aug  3 00:49:55 poliahu.ctio.noao.edu WindowServer[79]: Received display connect changed for display 0x3f003e
Aug  3 00:49:55 poliahu.ctio.noao.edu WindowServer[79]: Received display connect changed for display 0x3f003f

switching to the nvidia (discrete):

Aug  3 00:50:35 poliahu.ctio.noao.edu WindowServer[79]: Received display connect changed for display 0x42803c0
Aug  3 00:50:35 poliahu.ctio.noao.edu WindowServer[79]: Received display connect changed for display 0x3f003d
Aug  3 00:50:35 poliahu.ctio.noao.edu WindowServer[79]: Received display connect changed for display 0x3f003e
Aug  3 00:50:35 poliahu.ctio.noao.edu WindowServer[79]: Received display connect changed for display 0x3f003f
Aug  3 00:50:35 poliahu.ctio.noao.edu WindowServer[79]: CGXMuxAcknowledge: Posting glitchless acknowledge
Aug  3 00:50:35 poliahu.ctio.noao.edu WindowServer[79]: MPAccessSurfaceForDisplayDevice: Set up page flip mode on display 0x042803c0 device: 0x10c678320  isBackBuffered: 0 numComp: 1 numDisp: 3
Aug  3 00:50:35 poliahu.ctio.noao.edu WindowServer[79]: Received display connect changed for display 0x42803c0

Hope that helps.
Francois



On 02/08/12 20:34, Greg KH wrote:
> On Wed, Aug 01, 2012 at 11:02:42PM -0500, Seth Forshee wrote:
>> On Wed, Aug 01, 2012 at 04:21:47PM -0700, Greg KH wrote:
>>> On Wed, Aug 01, 2012 at 05:54:00PM +0100, Matthew Garrett wrote:
>>>> On Tue, Jul 31, 2012 at 03:32:40PM -0700, Greg KH wrote:
>>>>
>>>>> With this series, does the latest MacBook work properly for the Intel
>>>>> graphics driver?  Or is this to resolve some other hardware issue?
>>>> Apple only seem to provide the ROM for the radeon. Intel normally
>>>> stands a much better chance of working without a ROM - the only thing it
>>>> really uses it for is the VBT, and I'm thinking about a couple of ways
>>>> of handlng that.
>>> Ok, thanks for letting me know.  For some reason, the gmux isn't working
>>> on the latest MacBook Pro so I can't get the vga switched to the Intel
>>> PCI device.  Rumor has it the osx tool at
>>> http://codykrieger.com/gfxCardStatus will switch into the Intel chip
>>> until the laptop is hard powered off, so it is possible, just need to
>>> figure out how to make the hardware do the switch...
>> There's a tool that enables some verbose logging which records all the
>> I/O to the gmux. It works for me with a Macbook Pro 8,2 running OS X
>> Lion, so you might give it a try.
>>
>> All you need to do is clone https://github.com/ah-/switcher.git, build,
>> and run switcher. If it works you'll see messages prefixed with AGC in
>> dmesg. Then you can use gfxCardStatus to force some switches between the
>> integrated and discrete cards. After that you'll want to grab
>> /var/log/kern.log to get the full logs of everything that happened.
>>
>> If you try this and it works, I'd appreciate it if you could send me a
>> copy of kern.log so I can apply the information towards getting graphics
>> switching into apple-gmux.
> Francois, any chance you can ty this and let Seth know the results?  I
> don't have OSX on my machine anymore to do this myself.
>
> thanks,
>
> greg k-h

