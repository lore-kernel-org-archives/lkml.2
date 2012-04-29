Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab2D2HTB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 03:19:01 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:55288 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab2D2HTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 03:19:00 -0400
Date: Sun, 29 Apr 2012 09:18:48 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: minyard@acm.org
Cc: Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        tcminyard@gmail.com
Subject: Re: [BISECTED] SOLVED ipmi_si not loading since 2.6.39
Message-ID: <20120429071848.GA2064@nik-comp.lan>
References: <4F96AD8C.9010105@acm.org> <20120424203745.GB2152@nik-comp.lan> <4F97135A.2060801@calxeda.com> <20120424213056.GC2152@nik-comp.lan> <4F9721C3.7000009@acm.org> <20120425042123.GA2067@nik-comp.lan> <4F982B0C.7050103@acm.org> <20120425175812.GA2037@nik-comp.lan> <20120428144343.GA6810@nik-comp.lan> <4F9CB6B6.50505@acm.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <4F9CB6B6.50505@acm.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 7552619 records (last update: 20120429)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi guys,

thanks for all Your help. Problem solved, I have to be very sorry about tha=
t :(
There was a boot script I wasn't aware of which we're using for setting IPM=
I and this
tried to load the module using
modprobe ipmi_si type=3Dkcs ports=3D0xca8 regspacings=3D4
THIS seems to have stopped working, but I think it was just wrong all the t=
ime, and is
now not needed at all. Just loading ipmi_si now works, so the system was ma=
ybe just
getting confused when trying to load module with wrong params (I was unload=
ing module
first, but seems like that wasn't enough).
So I'll just have this script fixed (or better removed).
I'm once again sorry for the fuss, I don't know much about how IPMI works a=
nd apparently
haven't gathered all the needed info.

Cheers!

nik



On Sat, Apr 28, 2012 at 10:34:14PM -0500, Corey Minyard wrote:
> On 04/28/2012 09:43 AM, Nikola Ciprich wrote:
>>> nothing on this address (with 3.4 kernel).
>>>
>>> on 2.6.32 I see:
>>> 0a30-0a3f : pnp 00:07
>>> 0b00-0b7f : pnp 00:0c
>>> 0ca2-0ca2 : ipmi_si
>>> 0ca3-0ca3 : ipmi_si
>>> 0cf8-0cff : PCI conf1
>>> 1180-119f : 0000:00:1f.3
>>>    1180-119f : pnp 00:0e
>>> d000-dfff : PCI Bus 0000:06
>>>    d000-d01f : 0000:06:00.0
>>>
>>> on 3.4-rc4:
>>>    0a30-0a3f : pnp 00:07
>>>    0b00-0b7f : pnp 00:0c
>>> 0cf8-0cff : PCI conf1
>>> 0d00-ffff : PCI Bus 0000:00
>>>    1180-119f : 0000:00:1f.3
>>>      1180-119f : pnp 00:0e
>>>    c000-cfff : PCI Bus 0000:06
>>>      c000-c01f : 0000:06:00.0
>>>
>> well, I wasn't able to figure out anything special :(
>> do You guys have any idea on what more I could check?
>> I'd be very grateful for any hints..
>> thanks a lot in advance
>> nik
>
> I do not know.  I just tried 3.2 and the head of the kernel tree and =20
> they both worked fine on my system, which is an old Intel server.
>
> I have a Supermicro system with IPMI, but it will take me a bit to get a =
=20
> working kernel there.
>
> Could you try with the module param "kcs_debug=3D7"?  That will give me =
=20
> some idea what the state machine is doing.
>
> At this point, if I can't reproduce, I can't do much.  I also don't see =
=20
> how that patch would make any difference if you hand-specify the=20
> parameters.
>
> -corey
>
>>
>>> I'll try comparing both kernels' dmesg output in more detail to see
>>> if there's some difference that might be important..
>>>
>>> n.
>>>
>>>
>>>
>>>
>>>> -corey
>>>>
>>>>> cheers!
>>>>> n.
>>>>>
>>>>>
>>>>>> -corey
>>>>>>
>>>>>>
>>>>>>> n.
>>>>>>>
>>>>>>>
>>>>>>> On Tue, Apr 24, 2012 at 03:55:54PM -0500, Rob Herring wrote:
>>>>>>>> On 04/24/2012 03:37 PM, Nikola Ciprich wrote:
>>>>>>>>> Hi Corey,
>>>>>>>>>
>>>>>>>>> I have this problem with 3.4-rc4 as well and it already contains
>>>>>>>>> b1608d69cb804e414d0887140ba08a9398e4e638, so this doesn't fix thi=
s problem..
>>>>>>>>>
>>>>>>>> Can you send the kernel log for the failing case.
>>>>>>>>
>>>>>>>> Rob
>>>>>>>>
>>>>>>>>> BR
>>>>>>>>>
>>>>>>>>> nik
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On Tue, Apr 24, 2012 at 08:41:32AM -0500, Corey Minyard wrote:
>>>>>>>>>> Looks like you might need change b1608d69cb804e414d0887140ba08a9=
398e4e638
>>>>>>>>>>
>>>>>>>>>> -corey
>>>>>>>>>>
>>>>>>>>>> On 04/23/2012 03:09 PM, Rob Herring wrote:
>>>>>>>>>>> On 04/21/2012 02:20 AM, Nikola Ciprich wrote:
>>>>>>>>>>>> Hi,
>>>>>>>>>>>>
>>>>>>>>>>>> here's further information Rob and Corey requested:
>>>>>>>>>>>>
>>>>>>>>>>>> on working system:
>>>>>>>>>>>>
>>>>>>>>>>>> [root@vbox4 ~]# cat /proc/ipmi/0/params
>>>>>>>>>>>> kcs,i/o,0xca2,rsp=3D1,rsi=3D1,rsh=3D0,irq=3D0,ipmb=3D0
>>>>>>>>>>>>
>>>>>>>>>>>> dmesg snippet:
>>>>>>>>>>>>
>>>>>>>>>>>> [   41.759319] ipmi message handler version 39.2
>>>>>>>>>>>> [   41.760690] ipmi device interface
>>>>>>>>>>>> [   42.765334] IPMI System Interface driver.
>>>>>>>>>>>> [   42.765336] ipmi_si: probing via hardcoded address
>>>>>>>>>>>> [   42.765337] ipmi_si: Adding hardcoded-specified kcs state m=
achine
>>>>>>>>>>>> [   42.765340] ipmi_si: Trying hardcoded-specified kcs state m=
achine at i/o address 0xca8, slave address 0x0, irq 0
>>>>>>>>>>>> [   42.765344] ipmi_si: Interface detection failed
>>>>>>>>>>>> [   42.770823] ipmi_si: probing via SMBIOS
>>>>>>>>>>>> [   42.770834] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 i=
rq 0
>>>>>>>>>>>> [   42.770836] ipmi_si: Adding SMBIOS-specified kcs state mach=
ine
>>>>>>>>>>>> [   42.770838] ipmi_si: probing via SPMI
>>>>>>>>>>>> [   42.770840] ipmi_si: SPMI: io 0xe4 regsize 1 spacing 1 irq 0
>>>>>>>>>>>> [   42.770841] ipmi_si: Adding SPMI-specified kcs state machine
>>>>>>>>>>>> [   42.770843] ipmi_si: Trying SMBIOS-specified kcs state mach=
ine at i/o address 0xca2, slave address 0x0, irq 0
>>>>>>>>>>>> [   42.798137] ipmi_si ipmi_si.0: Error clearing flags: cc
>>>>>>>>>>>> [   42.801011] ipmi_si ipmi_si.0: Found new BMC (man_id: 0x002=
a7c, prod_id: 0x0624, dev_id: 0x20)
>>>>>>>>>>>> [   42.801068] ipmi_si ipmi_si.0: IPMI kcs interface initializ=
ed
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> dmidecode:
>>>>>>>>>>>>
>>>>>>>>>>>> IPMI Device Information
>>>>>>>>>>>>             Interface Type: KCS (Keyboard Control Style)
>>>>>>>>>>>>             Specification Version: 2.0
>>>>>>>>>>>>             I2C Slave Address: 0x00
>>>>>>>>>>>>             NV Storage Device: Not Present
>>>>>>>>>>>>             Base Address: 0x0000000000000CA2 (I/O)
>>>>>>>>>>>>             Register Spacing: Successive Byte Boundaries
>>>>>>>>>>>>
>>>>>>>>>>>> Base Board Information
>>>>>>>>>>>>             Manufacturer: Supermicro
>>>>>>>>>>>>             Product Name: X9SCL/X9SCM
>>>>>>>>>>>>
>>>>>>>>>>>> (but we're experiencing this on various supermicro bords, ie X=
8DTL)
>>>>>>>>>>>>
>>>>>>>>>>>> Tried setting parameters by hand didn't help:
>>>>>>>>>>>>
>>>>>>>>>>>> modprobe ipmi_si type=3Dkcs addrs=3D0xca8 regspacings=3D1 regs=
izes=3D1 regshifts=3D0 irqs=3D0 slave_addrs=3D0x0
>>>>>>>>>>>>
>>>>>>>>>>>> (not sure whether I got them correct though, and values mostly=
 seem to me to be defaults anyways..)
>>>>>>>>>>>>
>>>>>>>>>>> It is working for me on a SuperMicro system with ubuntu oneiric=
 (3.0
>>>>>>>>>>> based).
>>>>>>>>>>>
>>>>>>>>>>> [597160.259728] ipmi_si: probing via SMBIOS
>>>>>>>>>>> [597160.259730] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 i=
rq 0
>>>>>>>>>>> [597160.259731] ipmi_si: Adding SMBIOS-specified kcs state mach=
ine
>>>>>>>>>>> [597160.259734] ipmi_si: probing via SPMI
>>>>>>>>>>> [597160.259735] ipmi_si: SPMI: io 0xe4 regsize 1 spacing 1 irq 0
>>>>>>>>>>> [597160.259737] ipmi_si: Adding SPMI-specified kcs state machine
>>>>>>>>>>> [597160.259739] ipmi_si: Trying SMBIOS-specified kcs state mach=
ine at
>>>>>>>>>>> i/o address 0xca2, slave address 0x0, irq 0
>>>>>>>>>>> [597160.378757] ipmi_si: Invalid return from get global enables=
 command,
>>>>>>>>>>> cannot enable the event buffer.
>>>>>>>>>>> [597160.382032] ipmi_si ipmi_si.0: Found new BMC (man_id: 0x00b=
980,
>>>>>>>>>>> prod_id: 0x0624, dev_id: 0x20)
>>>>>>>>>>> [597160.382040] ipmi_si ipmi_si.0: IPMI kcs interface initializ=
ed
>>>>>>>>>>> [597179.973960] ipmi device interface
>>>>>>>>>>> localadm@sandy1:~$ ipmitool bmc info
>>>>>>>>>>> Could not open device at /dev/ipmi0 or /dev/ipmi/0 or /dev/ipmi=
dev/0: No
>>>>>>>>>>> such file or directory
>>>>>>>>>>> Get Device ID command failed
>>>>>>>>>>> localadm@sandy1:~$ sudo ipmitool bmc info
>>>>>>>>>>> Device ID                 : 32
>>>>>>>>>>> Device Revision           : 1
>>>>>>>>>>> Firmware Revision         : 1.1
>>>>>>>>>>> IPMI Version              : 2.0
>>>>>>>>>>> Manufacturer ID           : 47488
>>>>>>>>>>> Manufacturer Name         : Unknown (0xB980)
>>>>>>>>>>> Product ID                : 1572 (0x0624)
>>>>>>>>>>> Product Name              : Unknown (0x624)
>>>>>>>>>>> Device Available          : yes
>>>>>>>>>>> Provides Device SDRs      : no
>>>>>>>>>>> Additional Device Support :
>>>>>>>>>>>         Sensor Device
>>>>>>>>>>>         SDR Repository Device
>>>>>>>>>>>         SEL Device
>>>>>>>>>>>         FRU Inventory Device
>>>>>>>>>>>         IPMB Event Receiver
>>>>>>>>>>>         IPMB Event Generator
>>>>>>>>>>>         Chassis Device
>>>>>>>>>>> Aux Firmware Rev Info     :
>>>>>>>>>>>         0x06
>>>>>>>>>>>         0x00
>>>>>>>>>>>         0x00
>>>>>>>>>>>         0x00
>>>>>>>>>>> localadm@sandy1:~$ uname -a
>>>>>>>>>>> Linux sandy1 3.0.0-16-generic #28-Ubuntu SMP Fri Jan 27 17:44:3=
9 UTC
>>>>>>>>>>> 2012 x86_64 x86_64 x86_64 GNU/Linux
>>>>>>>>>>>
>>>>>>>>>>> Rob
>>>>>>>>>>>
>>>>>>>>>>>> nik
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> On Sat, Apr 21, 2012 at 12:38:33AM +0200, Nikola Ciprich wrote:
>>>>>>>>>>>>> Hello,
>>>>>>>>>>>>>
>>>>>>>>>>>>> I was trying to find out why IPMI stopped working on new kern=
els. Since 2.6.39
>>>>>>>>>>>>> module loading ends with following message:
>>>>>>>>>>>>>
>>>>>>>>>>>>>      ipmi_si: Interface detection failed
>>>>>>>>>>>>>
>>>>>>>>>>>>> Then ipmitool is unable to control IPMI device.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Works for 2.6.38, doesn't work for 2.6.39, 3.0.28, 3.4-rc1.
>>>>>>>>>>>>>
>>>>>>>>>>>>> I got this bisected to following commit:
>>>>>>>>>>>>>
>>>>>>>>>>>>> commit a1e9c9dd3383e6a1a762464ad604b1081774dbda
>>>>>>>>>>>>> Author: Rob Herring<rob.herring@calxeda.com>
>>>>>>>>>>>>> Date:   Wed Feb 23 15:37:59 2011 -0600
>>>>>>>>>>>>>
>>>>>>>>>>>>>         ipmi: convert OF driver to platform driver
>>>>>>>>>>>>>
>>>>>>>>>>>>>         of_bus is deprecated in favor of the plain platform b=
us. This patch
>>>>>>>>>>>>>         merges the ipmi OF driver with the existing platform =
driver.
>>>>>>>>>>>>>
>>>>>>>>>>>>>         CONFIG_PPC_OF occurrances are removed or replaced wit=
h CONFIG_OF.
>>>>>>>>>>>>>
>>>>>>>>>>>>>         Compile tested with and without CONFIG_OF. Tested OF =
probe and
>>>>>>>>>>>>>         default probe cases.
>>>>>>>>>>>>>
>>>>>>>>>>>>>         Signed-off-by: Rob Herring<rob.herring@calxeda.com>
>>>>>>>>>>>>>         Signed-off-by: Grant Likely<grant.likely@secretlab.ca>
>>>>>>>>>>>>>
>>>>>>>>>>>>> I wonder whether this is a bug, or I'm doing something wrong?
>>>>>>>>>>>>>
>>>>>>>>>>>>> Thanks in advance!
>>>>>>>>>>>>>
>>>>>>>>>>>>> with best regards
>>>>>>>>>>>>>
>>>>>>>>>>>>> nik
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> --=20
>>>>>>>>>>>>> -------------------------------------
>>>>>>>>>>>>> Ing. Nikola CIPRICH
>>>>>>>>>>>>> LinuxBox.cz, s.r.o.
>>>>>>>>>>>>> 28. rijna 168, 709 01 Ostrava
>>>>>>>>>>>>>
>>>>>>>>>>>>> tel.:   +420 596 603 142
>>>>>>>>>>>>> fax:    +420 596 621 273
>>>>>>>>>>>>> mobil:  +420 777 093 799
>>>>>>>>>>>>>
>>>>>>>>>>>>> www.linuxbox.cz
>>>>>>>>>>>>>
>>>>>>>>>>>>> mobil servis: +420 737 238 656
>>>>>>>>>>>>> email servis: servis@linuxbox.cz
>>>>>>>>>>>>> -------------------------------------
>>>>>>>>>>> --
>>>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux=
-kernel" in
>>>>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.h=
tml
>>>>>>>>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>> --=20
>>> -------------------------------------
>>> Ing. Nikola CIPRICH
>>> LinuxBox.cz, s.r.o.
>>> 28. rijna 168, 709 01 Ostrava
>>>
>>> tel.:   +420 596 603 142
>>> fax:    +420 596 621 273
>>> mobil:  +420 777 093 799
>>>
>>> www.linuxbox.cz
>>>
>>> mobil servis: +420 737 238 656
>>> email servis: servis@linuxbox.cz
>>> -------------------------------------
>>
>>
>

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+c61gACgkQ3xdJJrLygV6h8wCgvfNsGrkekrJr7/SIsqFgNFf0
kVMAoKkQrjjENk7znMQ/Zn4y/1Fz2BW7
=K71Q
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
