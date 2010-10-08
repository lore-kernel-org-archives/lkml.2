Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab0JHKmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:42:03 -0400
Received: from asmtpout029.mac.com ([17.148.16.104]:53858 "EHLO
	asmtpout029.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab0JHKmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:42:00 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=5 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx engine=6.0.2-1004200000 definitions=main-1010080038
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-08_09:2010-10-08,2010-10-08,1970-01-01 signatures=0
Subject: Re: kgdb errors with serial console
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <4CAE5B40.3070701@windriver.com>
Date: Fri, 08 Oct 2010 14:41:14 +0400
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Message-id: <917F9CCC-F3D3-4E23-B955-412F08CE8E2E@mac.com>
References: <BDD07355-7199-4A2E-8426-F6D43EA5D313@mac.com>
 <4CAE4BB6.7080509@windriver.com>
 <7BA01CAF-DD25-4AB6-9498-8AB89E2EDDE1@mac.com> <4CAE5B40.3070701@windriver.com>
To: Jason Wessel <jason.wessel@windriver.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,
                      I'm getting eclipse target time outs, I've attached link to the video here : http://drop.io/kgdbwe01
 
On Oct 8, 2010, at 3:44 AM, Jason Wessel wrote:
> 
> Of course if you are willing to try something a bit more complex you can
> probably make use of being able to interactively break in with the
> eclipse gdb plugin, assuming your serial port is connected to a linux
> host, and it appeared that way based on your description.
> 
> On your host you could set up the following:
> 
> git clone git://git.kernel.org/pub/scm/utils/kernel/kgdb/agent-proxy.git
> cd agent-proxy
> make
> ./agent-proxy 4440^4441 0 /dev/ttyUSB0,115200 &
> 
> telnet localhost 4440
> 
> Now in your gdbinit file you replace the target remote with
> 
> target remote localhost:4441
> 
> The agent proxy should take care of sending the sysrq g for you, and the
> telnet window will provide you a look at the target console.

The agent-proxy suggestion was a lifesaver!!  It makes it so much easier to debug the target board, and you can run it as a normal user when connecting to /dev/ttyUSB0. 

I made the required changes to .gdbinit, and modified the Eclipse debugger settings to TCP/IP, with localhost and port 4441. 

I also then go to the telnet terminal session, and then type 

# echo g > /proc/sysrq-trigger
SysRq : DEBUG
Entering KGDB

and then launched eclipse debugger. It loads the vmlinux file, and a bunch of junk characters keep appearing continuously on the telnet session. 

After about a minute or so, Eclipse terminates the session saying that it timed out. You can see this in the video. I edited the video, in between to trim off the long wait, with the characters scrolling in the terminal session, to the point where it crashes.

Best regards,

Elvis Dowson



