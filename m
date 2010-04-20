Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab0DTPDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 11:03:15 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44105 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab0DTPDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 11:03:14 -0400
Message-ID: <4BCDC22C.8090306@mev.co.uk>
Date: Tue, 20 Apr 2010 16:03:08 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100406 Thunderbird/3.0.3
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Gustavo Silva <silvagustavosilva@gmail.com>,
       "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Gustavo Silva <silvagustavo@users.sourceforge.net>
Subject: Re: [PATCH] Staging: comedi: drivers: fix coding style issues in
 das08.c
References: <> <1271658070-10511-1-git-send-email-silvagustavo@users.sourceforge.net> <4BCD9B94.9090302@mev.co.uk> <20100420134233.GA27884@suse.de>
In-Reply-To: <20100420134233.GA27884@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/04/10 14:42, Greg KH wrote:
> On Tue, Apr 20, 2010 at 01:18:28PM +0100, Ian Abbott wrote:
>> On 19/04/10 07:21, Gustavo Silva wrote:
>>> This is a patch to the das08.c file that fixes up the following issues
>>> found by the checkpatch.pl tool.
>>
>>> -*/
>>>  /*
>>> -Driver: das08
>>> -Description: DAS-08 compatible boards
>>> -Author: Warren Jasper, ds, Frank Hess
>>> -Devices: [Keithley Metrabyte] DAS08 (isa-das08), [ComputerBoards] DAS08 (isa-das08),
>>> -  DAS08-PGM (das08-pgm),
>>> -  DAS08-PGH (das08-pgh), DAS08-PGL (das08-pgl), DAS08-AOH (das08-aoh),
>>> -  DAS08-AOL (das08-aol), DAS08-AOM (das08-aom), DAS08/JR-AO (das08/jr-ao),
>>> -  DAS08/JR-16-AO (das08jr-16-ao), PCI-DAS08 (das08),
>>> -  PC104-DAS08 (pc104-das08), DAS08/JR/16 (das08jr/16)
>>> -Status: works
>>> -
>>> -This is a rewrite of the das08 and das08jr drivers.
>>> -
>>> -Options (for ISA cards):
>>> -        [0] - base io address
>>> -
>>> -Options (for pci-das08):
>>> -        [0] - bus  (optional)
>>> -        [1] = slot (optional)
>>> -
>>> -The das08 driver doesn't support asynchronous commands, since
>>> -the cheap das08 hardware doesn't really support them.  The
>>> -comedi_rt_timer driver can be used to emulate commands for this
>>> -driver.
>>> -*/
>>> + * Driver: das08
>>> + * Description: DAS-08 compatible boards
>>> + * Author: Warren Jasper, ds, Frank Hess
>>> + * Devices: [Keithley Metrabyte] DAS08 (isa-das08),
>>> + * [ComputerBoards] DAS08 (isa-das08), DAS08-PGM (das08-pgm),
>>> + * DAS08-PGH (das08-pgh), DAS08-PGL (das08-pgl), DAS08-AOH (das08-aoh),
>>> + * DAS08-AOL (das08-aol), DAS08-AOM (das08-aom), DAS08/JR-AO (das08/jr-ao),
>>> + * DAS08/JR-16-AO (das08jr-16-ao), PCI-DAS08 (das08),
>>> + * PC104-DAS08 (pc104-das08), DAS08/JR/16 (das08jr/16)
>>> + * Status: works
>>> + *
>>> + * This is a rewrite of the das08 and das08jr drivers.
>>> + *
>>> + * Options (for ISA cards):
>>> + *             [0] - base io address
>>> + *
>>> + * Options (for pci-das08):
>>> + *             [0] - bus  (optional)
>>> + *             [1] = slot (optional)
>>> + *
>>> + * The das08 driver doesn't support asynchronous commands, since
>>> + * the cheap das08 hardware doesn't really support them.  The
>>> + * comedi_rt_timer driver can be used to emulate commands for this
>>> + * driver.
>>> + */
>>
>> This part of the patch would screw up some scripts we have (in the CVS
>> version of comedi) for extracting driver documentation from the source code.
> 
> What type of scripts are they and what is the requirements for them so
> that we know not to mess them up?

It's just a simple Perl script:

http://www.comedi.org/cgi-bin/viewvc.cgi/comedi/scripts/dump_doc?revision=1.2

It looks for a line beginning with 'Driver: ' and dumps that line and
following lines to standard output until it sees a line containing '*/'.
 Then all these blocks of text for the different drivers get
concatenated into a plain text drivers.txt file using a Makefile rule
like this:

Documentation/comedi/drivers.txt: $(COMEDI_DRIVER_FILES)
	for each in $(COMEDI_DRIVER_FILES); do $(srcdir)/scripts/dump_doc $$each;\
		done >$(srcdir)/Documentation/comedi/drivers.txt

(that's from
http://www.comedi.org/cgi-bin/viewvc.cgi/comedi/Makefile.am?revision=1.29 )

I dare say the script could be easily modified to cope with the initial
' * ' at the start of each line.

The continuation lines following the 'Devices: ' line will need to be
indented with one or more whitespace characters as in the original version.

There is another script in comedilib that take the contents of this file
and incorporates it into the Comedilib manual (in DocBook-XML format),
with some data extraction from the 'Driver:', 'Description:',
'Devices:', 'Author:' and 'Status:' header lines (and following
continuation lines) to produce document section headings and a table of
device names for each driver.  The resulting Comedilib chapter looks
like this:

http://www.comedi.org/doc/x1781.html

> And how about just using kerneldoc?

That should be possible, I guess by using a different script to produce
the drivers.txt file.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
