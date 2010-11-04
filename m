Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab0KDFvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 01:51:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41441 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab0KDFvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 01:51:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=R9LNWdGi1arPwnJfEUCT/TooBToh6ghNY8lLbBHUGJhrUXMyEL4KVVwIYxTYvhqztr
         mqTMUXOghcZ/NgBkbES/ZQCbUF6BE1poiZp48yTQgw3Xr0dkS+ntQuorsfdXfcg+VF7F
         T2qwGYbRRO9gJ9T91rOGBp76lkdAT1EZrcFc4=
Message-ID: <4CD249DE.1050301@gmail.com>
Date: Thu, 04 Nov 2010 07:51:26 +0200
From: Ron Rondis <ron.rondis@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 64 bit PCI BAR
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

The following section, from PCI spec, explain the mechanism for getting 
64 bit region size.

"64-bit (memory) Base Address registers can be handled the same, except 
that the second
32-bit register is considered an extension of the first; i.e., bits 
32-63. Software writes
0FFFFFFFFh to both registers, reads them back, and combines the result 
into a 64-bit value.
Size calculation is done on the 64-bit value."

In pci/proce.c the implementation is:

read low bar
write ~0 to low bar
read low bar
write low bar

read high bar
write ~0 to high bar
read high bar
write high bar


Can someone explain the conflict between the spec and the implementation?


Please add me to CC.


Thanks,
Ron

