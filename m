Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118Ab1COEax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 00:30:53 -0400
Received: from fox.seas.upenn.edu ([158.130.68.12]:48659 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab1COEat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 00:30:49 -0400
Message-ID: <4D7EEB64.5050402@seas.upenn.edu>
Date: Tue, 15 Mar 2011 00:30:28 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110303 Icedove/3.0.11
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        micki@n-trig.com, rydberg@euromail.se, chatty@enac.fr
Subject: Re: [PATCH 1/2] hid-ntrig: sysfs nodes for modes
References: <1299829072-19489-1-git-send-email-rafi@seas.upenn.edu> <20110311081843.GE10807@core.coreip.homeip.net> <4D79F1DD.10009@seas.upenn.edu> <20110313062700.GC31566@core.coreip.homeip.net>
In-Reply-To: <20110313062700.GC31566@core.coreip.homeip.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-03-14_05:2011-03-14,2011-03-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1012030000 definitions=main-1103140221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/13/11 01:27, Dmitry Torokhov wrote:
> On Fri, Mar 11, 2011 at 04:56:45AM -0500, Rafi Rubin wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> User desires aren't exactly my specialty.  I just know the ntrig windows control
>> panel gives the user that control with cute little radio buttons.
>>
>> Would it be cleaner to expose the control with an ioctrl or some other mechanism?
>>
>> I do have user space tools for mode and calibration, but that requires unbinding
>> the device, and just seems sloppier.  But if this really is inappropriate to add
>> the sysfs nodes, at least there's still some solution.
> 
> No, this is not inappropriate, I was just musing how useful they are. Do
> we foresee users really using them or if is it more "we export because we can".
> I.e. in which cases the default mode is not suitable?

Calibration is handy, I haven't counted how many users have asked for help and
calibrating fixed their problems.  It can be run with libusb from userspace, but
that requires unbinding the device and running more stuff with elevated
privileges.  X hotswap of input devices has improved, but transient settings are
still lost.  And of course we're still talking pain for any application that
uses the device directly but doesn't handle hotswap.


As for mode setting, I know I have used that feature through userspace and my
sysfs nodes.  But that doesn't mean other people care about that feature.
N-trig put it in the firmware and their windows control panel, perhaps Micki or
someone else from the company would care to weigh in on that.

>> Since you brought it up, I am thinking of removing some of the other nodes soon.
>>  I've learned the physical and logical ranges are already exposed both through
>> the event nodes and debugfs.  Also, I have better filtering that so far seems
>> not to need as many parameters so I should be able to remove those nodes as well.
>>
> 
> Well, that's the issue with sysfs - it really forms kernel ABI so
> removing something that was once added is hard.

Hm, sorry I was careless about that.  I was hoping for some feedback on the
tuning parameters and hoped to be able to remove some of those nodes once we
established good values.  Of course almost nobody actually used them and let me
know :(

Rafi
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJNfuthAAoJEPILXytRLnK2brkP/1bj6+i+/umuuyJq58PBe8P1
+bagO7Rz2NUee7o++wdJSUW+GaL7lGLOySKi+gJ5N7vYHn7AekWT4lIUqjv0PinE
mnI2nhFqnWTyTGjbOFxazR4o6DG7YcdSmHDvLbqUOh7mJbfxZI9XqFLV7E+mCDpG
7VjtZMANq2Ju2/qr5B1h53WzvufEoXGhNIRyMpJbEaFAFjR0iG4UmTKNtsTPvNVt
knzZfkKk4VX+h72WgvvQ85/ViTLtBQXIU/AFNlgn3hysM+orA/OF1Rp0OX5aAz/p
rDQeJCYtP6GK1pzIbir2SS1tvnFfm+G2gxIDkBeh4ahL/x6z0D8EHl6rdZiodVeK
bxaXRQJh8cFTWMUDrySlzVf88ZQRvNVK8+bRcNXlqWnCDoY2xopPrVGBninZwvIs
laiWN64di1HVn7hgoy/iW/L2SA8NC9wQjd8X5TL9+EH0lToUvHxfqXooJzq31iwI
UuHPpVdyIeBTVl81zj+/cHWi4mEXnnjoANbjWOnTfFwDzDwaxop4/OwKhl4yebRM
t8ZJGPAJAzlse+FeuEd20P6kRvN7AUzBaG6Zwvyi9IRPfOPbsTF86jllNxJaEv4Y
ExuR6QZQ+HFRveojqhoHgD79nvgtQZlpVvIIggnsm0ImQ0pmSMMuhMjSb+Mna8c+
RfiTBxl9o6vVutQ4AkTk
=QQ0T
-----END PGP SIGNATURE-----
