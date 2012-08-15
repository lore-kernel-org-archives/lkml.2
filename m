Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab2HOKkD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 06:40:03 -0400
Received: from hera.cwi.nl ([192.16.191.8]:42834 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786Ab2HOKkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 06:40:01 -0400
Message-ID: <502B7C77.3010005@cwi.nl>
Date: Wed, 15 Aug 2012 12:39:51 +0200
From: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: paulus@samba.org, mingo@redhat.com, acme@ghostprotocols.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [perf] make clean problematic bashism
References: <502B714E.4010700@cwi.nl> <1345026408.31459.60.camel@twins>
In-Reply-To: <1345026408.31459.60.camel@twins>
Content-Type: multipart/mixed;
 boundary="------------040000000705010309050504"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040000000705010309050504
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 08/15/2012 12:26 PM, Peter Zijlstra wrote:
> On Wed, 2012-08-15 at 11:52 +0200, Wouter M. Koolen wrote:
>> Dear perf maintainers,
>>
>> I attempted to compile perf 3.5.1 without worrying about installing
>> dependencies first. The resulting error messages were quite helpful, and
>> led me to install a bunch of development libraries and flex.
>>
>> Unfortunately, after installing flex the build still failed, even after
>> make clean.
>>
>> The reason for this was a bunch of generated empty flex files in util/
>> that were not removed by make clean. They are intended to be erased,
>> since the Makefile executes
>>
>> rm -f util/*-{bison,flex}*
>>
>> however, this command does not remove the files. I guess because {,}
>> alternatives are only special in bash but the makefile is run with some
>> other shell?
>
> ISTR us getting a number of such patches, did we miss a site, acme?
>
>> I got perf to compile now, but thought you would be interested to know
>> about this little problem.
>>
>> With kind regards,
>>
>> Wouter Koolen
>>
>>
>> PS: as a side note: GNU make has the .DELETE_ON_ERROR: special target,
>> which removes the target file when its generating command fails. This
>> would have prevented my problem and sounds like a good idea in general.
>> Maybe perf could make use of this feature when on GNU make?
>
> I don't think we build with anything but gnu make, mind sending a patch
> implementing your suggestion?



Hi Peter,

Some more information: my system has /bin/sh set to dash. I remember a 
question about this during Debian installation. I guess Ubuntu does 
something similar viz. https://lkml.org/lkml/2012/5/4/90

Patch attached :)

With kind regards,

Wouter

--------------040000000705010309050504
Content-Type: text/plain;
 name="delete_on_error"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="delete_on_error"

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 0eee64c..29b2373 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1,3 +1,5 @@
+.DELETE_ON_ERROR:
+
 include ../scripts/Makefile.include
 
 # The default target of this Makefile is...

--------------040000000705010309050504--
