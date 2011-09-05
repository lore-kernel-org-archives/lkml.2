Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab1IEPGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 11:06:05 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:58556 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208Ab1IEPGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 11:06:03 -0400
X-Greylist: delayed 1300 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Sep 2011 11:06:02 EDT
Message-ID: <4E64E02E.3060103@ispras.ru>
Date: Mon, 05 Sep 2011 18:43:58 +0400
From: Eugene Shatokhin <spectre@ispras.ru>
Reply-To: Eugene Shatokhin <spectre@ispras.ru>
Organization: ISPRAS
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.21) Gecko/20110830 Thunderbird/3.1.13
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC] Dynamic Analysis of Kernel Modules with KEDR Framework
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a request for comments and suggestions concerning KEDR 
(http://kedr.berlios.de/), a framework to facilitate dynamic analysis and 
testing of kernel modules on x86 systems, both 32- and 64-bit. In its features, 
KEDR resembles Driver Verifier, an error detection tool for kernel-mode software 
in Microsoft Windows. The development of KEDR began in 2010, the latest stable 
version (0.3) was released this June.

The framework is distributed under the terms of GPL v2.

The detailed description of KEDR is in the online documentation: 
http://kedr.berlios.de/kedr-doc/index.html

There is also a brief "Getting Started" tutorial for KEDR there that shows how 
to set it up and demonstrates the basic operations: 
http://kedr.berlios.de/kedr-doc/getting_started.html

KEDR-based tools operate on the kernel module chosen by the user ("target 
module") rather than on the kernel as a whole.

Like many user-space dynamic analysis systems, KEDR features a plugin-based 
architecture. The core of the framework instruments the target module to allow 
interception of the function calls it makes. The idea is simple: the core can 
replace the calls to, say, __kmalloc() with the calls to a function having the 
same signature. That "replacement function" is provided by a plugin to the core 
and can do almost anything. The plugins actually collect and analyze the data 
about the calls and perform other operations. More detailed description is 
available here:
http://kedr.berlios.de/kedr-doc/using_kedr.html#how_kedr_works

Different analysis systems can be built using this approach. For example, KEDR 
framework currently provides the following tools:

- memory leak detector for both slab and page allocation operations;
- fault simulation facilities working according to user-defined scenarios ("what 
to make fail when") that can be changed in runtime;
- convenience tools for call tracing.

Besides that, other kinds of data collection and analysis can be implemented 
based on the framework.

Most of the time, KEDR does not require rebuilding the kernel and the module 
under analysis. The source code of the kernel and the module is not needed for 
the analysis as well. KEDR instruments the memory image of the loaded target 
module (changes appropriate call and jump offsets) before the module begins its 
initialization. Kernel notification system and the instruction decoding 
facilities from the implementation of KProbes are used to make this possible.

KEDR-based tools could complement the systems like Kmemleak, Fault Injection 
framework and SystemTap that seem to be more oriented towards system-wide 
analysis (although operating on a chosen module only is possible with at least 
Fault Injection framework and SystemTap). Some of the differences between KEDR 
and these systems are outlined here:
http://openfacts2.berlios.de/wikien/index.php/BerliosProject:KEDR_-_Kmemleak
http://openfacts2.berlios.de/wikien/index.php/BerliosProject:KEDR_-_FI

So far, several problems in the real-world kernel modules have been found with 
the help of our framework:
http://openfacts2.berlios.de/wikien/index.php/BerliosProject:KEDR_-_Problems_Found
These problems have been confirmed and fixed by the developers of the respective 
file system modules and device drivers.

It is possible to integrate KEDR with the testing frameworks like Autotest to 
enhance the existing tests with a memory leak detection, fault simulation 
capabilities, etc. One of the examples of how this can be done is described here:
http://openfacts2.berlios.de/wikien/index.php/BerliosProject:KEDR_-_HowTo_Autotest

2 of 3 issues in ath5k driver we have found, were detected by KEDR working in 
conjunction with Autotest.
Analysis of ext4 file system module was performed using KEDR with the tests from 
the Linux Test Project.

Of course, our system has its limitations (see 
http://kedr.berlios.de/kedr-doc/overview.html#overview.limit). Still, despite 
all these, the system has proven to be useful so far.

For now, we plan to maintain KEDR outside of the kernel, similar to how 
SystemTap is maintained.

If you have any comments or suggestions on how we can make the framework better, 
please let me know. We would like to make KEDR more useful for the kernel 
developers and perhaps for the developers of the testing and certification 
systems for kernel mode software.

Regards,
Eugene

