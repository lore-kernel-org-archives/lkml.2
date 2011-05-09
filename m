Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1EIUcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 16:32:54 -0400
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:64366 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751417Ab1EIUcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 16:32:53 -0400
X-Greylist: delayed 871 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 May 2011 16:32:53 EDT
Message-ID: <4DC84C0A.2070503@blueyonder.co.uk>
Date: Mon, 09 May 2011 21:18:18 +0100
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8 ThunderBrowse/3.3.5
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] misc: Driver for Silicon Labs Si570 and compatibles
References: <4DB17A3B.3060609@blueyonder.co.uk> <20110509183138.GB4964@ericsson.com>
In-Reply-To: <20110509183138.GB4964@ericsson.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=RQ36K_f0x-kA:10 a=jP4ZM9dVWk4A:10 a=3NElcqgl2aoA:10 a=k1j_C7plYBUA:10 a=8nJEP1OIZ-IA:10 a=z323o3TU7AUPA-8HYK4A:9 a=QW5G9V1pVz6IuJCjjeMA:7 a=wPNLvfGTeEIA:10 a=O--OGzHkBvRHjPyo:21 a=9HG78xlikQ0nwlnu:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/11 19:31, Guenter Roeck wrote:
> Hi Sid,
>
> On Fri, Apr 22, 2011 at 08:53:15AM -0400, Sid Boyce wrote:
>> Guenter Roeck wrote:
>> Depends. In our case, turns out the devices consuming the clock
>> have user mode drivers. Lots of history there, but the chip vendors
>> provide those user mode drivers, and the teams responsible for
>> integrating the drivers decided to not rewrite it to kernel mode drivers.
>> Also, for special purposes such as margining, it is necessary to control
>> the clock from userspace. So, for our use case, I need the user-visible
>> interface. I _don't_ need the kernel interface, at least not right now,
>> which is why I did not add it.
>>
>> Browsing through the web, it seems the chip is somewhat popular with
>> Amateur Radio. No idea if it would ever be controlled for such a purpose
>> from Linux, but if so, it would also require a user configurable frequency.
>>
>> If there is a better place for such a driver than misc, please let me know.
>>
>> Thanks,
>> Guenter
>> =============================================================================
>> Support for these devices included in several Amateur radio programs
>> tend to differ greatly which means reinventing the wheel in most of them.
>> Programs like Linrad, sdr-shell, quisk, lysdr, ghpsdr3, etc.
>> It's a small addition to the kernel that would significantly help in the
>> development of software for the myriad of SDR (Software Defined Radio)
>> designs based on this chip family.
>> I have 5 Amateur Radio transceivers using this chip and 2 more soon to
>> be added.
>> They are all open hardware heavily reliant on Linux.
>> The addition of UAC2 (USB Audio Class 2) kernel support has helped our
>> SDR hardware design efforts significantly.
>> I and the rest of the Linux SDR community would be happy to see it included.
>> Regards
>> Sid.
>
> Thanks for the feedback. Somehow I missed your reply at the time.
>
> As you probably have noticed from the discussion, I seems to be unlikely that
> the driver will be accepted into the kernel, at least not unless there is
> significant demand for it from others.
>
> It may help if you can provide a list of requirements from your side (do you need
> a kernel API ? Do you need an ABI to set the frequency from applications ?).
>
> I would be happy to provide and maintain the driver as separate patch until it
> is accepted (if that ever happens), and work with application maintainers to
> integrate it. Let me know if there is interest, and feel free to forward this
> e-mail to interested parties.
>
> Thanks,
> Guenter
>

Thanks Guenter,
I discussed the driver with other members of the SDR groups who have 
also looked at your posting.

One seeing your driver I thought it might offer a way of offloading 
si570 communication to the driver but there are other functions that are 
needed by other OS's and they are all part of the outboard 
microprocessor based firmware.

At present there are user programs that are used to control the si570 
through an attached USB device that is coded with a command set specific 
to the SDR hardware and not only to the si570.

Currently the PC drives a ATTiny85 or ATmega via the USB and it's the 
microprocessor that is flashed with firmware that controls the si570 
with i2c commands and the rest of the SDR communication.
Software program <-->  USB <--> ATmel chip <--> SDR hardware via the i2C 
bus.

It's felt that your driver would be suited to an embedded platform that 
includes the si570, but not for current PC based hardware.

The current linux program used is "usbsoftrock" and the list of commands 
below shows it's to control other non-si570 functions such as switching 
Band Pass and Low Pass filters, transmit with a PTT signal, providing CW 
tones and reading the state of the morse key for transmitting morse 
code, but as you can see interacting with the si570 is a major part of 
it's job.

Other programs have used the usbsoftrock ideas to communicate with SDR 
receiver and transceiver hardware, these include hamlib Linrad and 
sdr-shell being the major ones.

# usbsoftrock
usbsoftrock 1.0.2
usage: usbsoftrock [OPTION] COMMAND

OPTION is one or more of
   -a                             Advanced firmware present
                                  i.e. let the firmware calculate registers
   -d                             Enter a mode that listens for commands 
via UDP.
   -h                             PTT status by reading hardware port
                                  Mobo only.
   -i <address>                   I2C address in DECIMAL (DEFAULT = 85 
(0x55))
   -m <multiplier>                Multiplication factor for frequency 
(DEFAULT = 4)
   -p <port num>                  Port to listen for UDP datagrams 
(DEFAULT = 19004)
   -s <startup frequency MHz>     Factory programmed startup frequency 
(DEFAULT = 56.32)
   -u <serial number>             Serial Number of Device
   -v                             Verbose output (fairly useful)
   -vv                            Even more verbose output (debugging)
   -x <calibrated xtall freq MHz> Corrected XTALL frequency of Si570 
device calculated
                                  through the use of the calibrate 
command immediately
                                  after startup.
COMMAND is one of
   calibrate (may require -s option)
   getfreq
   getregisters
   interactive
   getptt                                 (-h option for Mobo only)
   getkeys                                (PE0FKO+TF3LJ+Mobo)
   gettone
   ptt {on|off}
   set bpf {on|off}                       (PE0FKO+TF3LJ+Mobo)
   set bpf_addr <band> <filter>           (PE0FKO >= 15.12+Mobo)
   set bpf_point <crossover> <f in MHz>   (PE0FKO+TF3LJ+Mobo)
   set lpf {on|off}                       (TF3LJ+Mobo only)
   set lpf_addr <band> <filter>                   "
   set lpf_point <crossover> <f in MHz>           "
   set freq <frequency in MHz>
   set si570_addr <i2c address in decimal>
   set si570_multiplier [band] <decimal factor>  (PE0FKO>=15.12+Mobo)
   set startup <frequency in MHz>         (PE0FKO+TF3LJ+Mobo)
   set xtall <frequency in MHz>           (PE0FKO+TF3LJ+Mobo)
   status

   where TF3LJ = Lofturs AtMega168 derivative
         Mobo  = Mobo 4.3 Project AT90USB162 Firmware
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Senior Staff Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks
