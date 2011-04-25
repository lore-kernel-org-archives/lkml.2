Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab1DYGWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 02:22:50 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:39108 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1DYGWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 02:22:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GDZ1yTnMaO7s273idERdPku1bAmsMksQvAAcbjFCldcRoK2sgSFsPutn0xfY75YE4F
         tcXOsW5TTzRnTtorQfdSCvflmtt3TBGAE9k1tE6S+bdxBIMfhFYIufao8ip0ZjiMhMek
         2rBKqHz7ROhzQIxyKWiujrwDbTr5ISknqbdWw=
Message-ID: <4DB51333.7060809@gmail.com>
Date: Mon, 25 Apr 2011 16:22:43 +1000
From: Graeme Russ <graeme.russ@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        U-Boot Users <u-boot@lists.denx.de>
Subject: Re: Expanding checkpatch for non-linux (specifically U-Boot) use
References: <4DB50854.8090700@gmail.com> <1303711340.1745.30.camel@Joe-Laptop>
In-Reply-To: <1303711340.1745.30.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/04/11 16:02, Joe Perches wrote:
> On Mon, 2011-04-25 at 15:36 +1000, Graeme Russ wrote:
>> There has been a bit of discussion lately on the U-Boot mailing list
>> regarding the use of checkpatch for U-Boot patches (see
>> http://lists.denx.de/pipermail/u-boot/2011-April/090954.html)
>>
>> U-Boot uses the Linux coding style and checkpatch is therefore a very good
>> tool for us to use to check style compliance. However, checkpatch has a few
>> Linux specific checks which throw up false warnings for U-Boot patches like:
>>
>> WARNING: consider using kstrto* in preference to simple_strto*
>> WARNING: Use #include <linux/$file> instead of <asm/$file>
>>
>> Also, checkpatch seems to be checking not only patched lines, but context
>> lines as well. There is a policy for U-Boot patches to not intermix
>> whitespace / code cleanup changes and functional changes in in the same
>> patch. So to achieve zero warnings and errors, the submitter is forced to
>> create an additional code-cleanup patch in addition to the functionality
>> patch. The code cleanup can end up being significantly larger than the
>> functionality change which discourages casual submitters.
>>
>> So I have a pretty simple question to ask of LKML - Will checkpatch patches
>> to create a 'U-Boot' command-line option to explicitly filter out Linux
>> specific warnings and errors ever be accepted into checkpatch, or will we
>> be required to create and maintain a U-Boot specific version?
>>
>> P.S. If you could please keep the U-Boot mailing list Cc'd, that would be
>> appreciated
> 
> Hi Graeme.
> 
> Perhaps some sort of .checkpatch.conf file
> could be introduced which could be linked to
> specific types of errors/warnings/checks
> that should be reported or ignored.
> 
> checkpatch has central routines to emit messages.
> 
> sub ERROR {
> 	if (report("ERROR: $_[0]\n")) {
> 		our $clean = 0;
> 		our $cnt_error++;
> 	}
> }
> sub WARN {
> 	if (report("WARNING: $_[0]\n")) {
> 		our $clean = 0;
> 		our $cnt_warn++;
> 	}
> }
> sub CHK {
> 	if ($check && report("CHECK: $_[0]\n")) {
> 		our $clean = 0;
> 		our $cnt_chk++;
> 	}
> }
> 
> For instance, warnings could be changed to include
> a new unique identifier for each message.
> 
> from
> 	WARN("Signed-off-by: is the preferred form\n" .
> 					$herecurr);
> to
> 	WARN($WARN_SIGN_OFF,
> 	     "Signed-off-by: is the preferred form\n" .
> 					$herecurr);
> 
> and the ERROR/WARN/CHK routines could be extended to use
> entries in the .conf file to enable/disable each message.
> 
> uboot could then use an appropriate .conf file.
> 

I like this - And checkpatch.pl could set the default options for 'Linux
flavour' so Linux would not need a .conf file :)

BUT - The question still remains - Will patches for obviously non-Linux
related 'features' of checkpatch be welcomed and incorporated into checkpatch?

Regards,

Graeme
