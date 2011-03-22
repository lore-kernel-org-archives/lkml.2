Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab1CVKl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:41:27 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:41229 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab1CVKlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:41:25 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D887D1E.90503@cam.ac.uk>
Date: Tue, 22 Mar 2011 10:42:38 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
CC: "Cai, Cliff" <Cliff.Cai@analog.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Drivers <Drivers@analog.com>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        Cliff Cai <cliff@analog.com>
Subject: Re: [PATCH RESEND v2]IIO driver for Analog Devices Digital Output
 Gyroscope ADXRS450
References: <1300526846-27183-1-git-send-email-cliff.cai@analog.com> <4D878D8B.6070902@cam.ac.uk> <DB904C5425BA6F4E8424B3B51A1414D167E03359CD@NWD2CMBX1.ad.analog.com> <544AC56F16B56944AEC3BD4E3D5917713754315B05@LIMKCMBX1.ad.analog.com>
In-Reply-To: <544AC56F16B56944AEC3BD4E3D5917713754315B05@LIMKCMBX1.ad.analog.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/11 08:16, Hennerich, Michael wrote:
> Cai, Cliff wrote on 2011-03-22:
>>
>>
>>> -----Original Message-----
>>> From: Jonathan Cameron [mailto:jic23@cam.ac.uk]
>>> Sent: 2011年3月22日 1:40
>>> To: Cai, Cliff
>>> Cc: linux-iio@vger.kernel.org; linux-kernel@vger.kernel.org; Drivers;
>>> device-drivers-devel@blackfin.uclinux.org; Cliff Cai
>>> Subject: Re: [PATCH RESEND v2]IIO driver for Analog Devices Digital
>>> Output Gyroscope ADXRS450
>>>
>>> On 03/19/11 09:27, cliff.cai@analog.com wrote:
>>>> From: Cliff Cai <cliff.cai@analog.com>
>>>>
>>>> Change v2:v1:
>>>>
>>>> Make modification according to Michael Hennerich's comments,
>>>> correct the spi transfer way,use existing sysfs interfaces.
>>> Hi Cliff,
>>>
>>> As you are proposing a couple of new interfaces we need to have
>>> documentation for them. They are quad and dynamic_null_correction. We
>>> need to first establish whether they are of general utility and hence
>>> should be in the main abi doc. The quadrature one isn't something I've
>>> seen before. Is it common in gyros?
>>
>> I'm not sure about this.
>> Michael,do you have any ideas?
> 
> The ADXRS450 is a quite new part and features a new sensor design -
> So I don't think the quadrature error is to date very common.
> It might become in future...
> 
> From the datasheet:
> 
> "The quad sensor design rejects linear and angular
> acceleration, including external g-forces and vibration. This is
> achieved by mechanically coupling the four sensing structures
> such that external g-forces appear as common-mode signals
> that can be removed by the fully differential architecture implemented in the ADXRS450."
> 
> "The quad memory registers contain a value corresponding to the amount of
> quadrature error present in the device at a given time.
> Quadrature can be likened to a measurement of the error of the motion of the
> resonator structure, and can be caused by stresses and aging effects.
> The quadrature data is filtered to 80 Hz and can be read frequently to
> detect sudden shifts in the level of quadrature.
> The data is presented as a 16-bit, twos complement number."
> 
Cool. So what is a good general name for this?  I guess from this description
if it were in a multi axis device you would have this measure for each axis?

So perhaps gyro_z_quadrature_correction_raw?  This thing also looks
rather similar to a dynamically changing calibbias. Perhaps we need another
term for a general dynamic linear (I think this is linear) correction inside
a device?

Perhaps go with a gyro specific term for now and wait to see if we get
many more parts with this feature...
>>
>>> Dynamic null correction looks like it should be gyro_z_calibbias to
>>> me but I could be wrong.  The doc says "
>>> The user can make small adjustments to the rateout of the device by
>>> asserting these bits. This 10-bit register allows the user to adjust
>>> the static rateout of the device by up to ±6.4°/sec.
>>> "
>>>
>>> which makes me think it is an internally applied offset on the output
>>> signal and hence calibbias in our abi.
>>
>> Thanks
>>
>>> Other than that, various minor nitpicks inline.
>>>
>>> Jonathan
> 
> Greetings,
> Michael
> 
> --
> Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
> Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368; Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin, Margaret Seif
> 

