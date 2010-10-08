Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752Ab0JHVgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 17:36:38 -0400
Received: from asmtpout030.mac.com ([17.148.16.105]:33429 "EHLO
	asmtpout030.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab0JHVgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 17:36:37 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=5 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx engine=6.0.2-1004200000 definitions=main-1010080146
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-08_15:2010-10-08,2010-10-08,1970-01-01 signatures=0
Subject: Re: kgdb errors with serial console
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <4CAF19FA.7010206@windriver.com>
Date: Sat, 09 Oct 2010 01:36:16 +0400
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Message-id: <D5727416-A7F9-4445-BB01-6EBA63C9FB7C@mac.com>
References: <BDD07355-7199-4A2E-8426-F6D43EA5D313@mac.com>
 <4CAE4BB6.7080509@windriver.com>
 <7BA01CAF-DD25-4AB6-9498-8AB89E2EDDE1@mac.com>
 <4CAE5B40.3070701@windriver.com>
 <917F9CCC-F3D3-4E23-B955-412F08CE8E2E@mac.com> <4CAF19FA.7010206@windriver.com>
To: Jason Wessel <jason.wessel@windriver.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,
                     I've reproduced the log file below. I don't know how to interpret this, do you see anything wrong in the log fie?

On Oct 8, 2010, at 5:17 PM, Jason Wessel wrote:
> 
> If you add the following to your .gdbinit it will at least tell you what
> happened at the end.
> 
> set remotelogfile /tmp/gdb_serial_log.txt

w +$qSupported#37
r +$#00
w +$Hg0#df
r +$OK#9a
w +$?#3f
r +$S05#b8
w +$Hc-1#09
r +$OK#9a
w +$qC#b4
r +$QC00000000fffffffe#43
w +$qAttached#8f
r +$#00
w +$qOffsets#4b
r +$#00
w +$g#67
r +$140000009301008001000000844ec7c0acf16fc067000000010000000700000000e823cf00e823cf930100209301004028de58c0b0de58c0749409c0849409c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000093010040#aa
w +$mc0099484,4#a2
r +$ffdeffe7#fd
w +$mc0099480,4#9e
r +$5ff07ff5#69
w +$mc0099484,4#a2
r +$ffdeffe7#fd
w +$mc0099480,4#9e
r +$5ff07ff5#69
w +$mc0099484,4#a2
r +$ffdeffe7#fd
w +$mc0099484,4#a2
r +$ffdeffe7#fd
w +$mc0099484,4#a2
r +$ffdeffe7#fd
w +$qSymbol::#5b
r +$#00
w +
c cd /tool/patches/android-rowboat-froyo-2.2-patchwork/kernel
c info proc
End of log


> It would be good to know if eclipse timed out and it just detached from
> the target, or if some command crashed gdb.  It is purely a guess, but
> it is probably eclipse requesting lots of information and simply timing out.
> 
> 
> I would not expect the terminal session to crash.  If an oops is
> printed, it means there is an internal kgdb problem.

I don't think kgdb crashed. It seems to be working reliably on the target side. If I restart the debug session, it receives the sysreq + g command and starts the debugger. 

Best regards,

Elvis Dowson
