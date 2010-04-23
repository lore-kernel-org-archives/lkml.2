Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab0DWQzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:55:04 -0400
Received: from web34404.mail.mud.yahoo.com ([66.163.178.153]:25537 "HELO
	web34404.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754687Ab0DWQzA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:55:00 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Apr 2010 12:55:00 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=RRg4zuQc8vCqgvR2pUGr5Q0zUgPHjwq7HOw+PEJ07jZo+YpmQ1TV8vTipsIjrJPNiyK5nLupIS8eesTvU9+dryeYaGQnAWdEphox6pjEn01NRKUKsM8WnHXr+ORJiPu3Hm5YE/DaLlRnjtdhp4VcodTdC/6hEId+Y3tGdUIDlco=;
Message-ID: <111445.29577.qm@web34404.mail.mud.yahoo.com>
X-YMail-OSG: .4KBYpkVM1maaa3O2x1GlV4WVYhz09HPgGlShNBfI8XjGDp
 bCWY8u3yQilcl1hW8mbnN.Wm3dlb35UswTevzdbyHsR1DKf5O_oGYEJLfBzM
 ciiN4mmUaUTVjBcTt0dU1TwY6chseFlbb7qjB_VWSQ_dPx5.dSYWAFnCqljP
 UsrifkazhLL5OfX1mlAqvULqWQz3wO9V_N5m6qe.wlgQBF0zR8T7fuo_j50m
 0eJCC6.e4LvanmEpGYk.UpkadXh3ElwB1telLXTrwIQyFSCY3nzCynTBY76E
 ytcbLK4GBn2.HeLtdpJ.cSzDpwNQ1GoUyeAiJ00VA1UYYyBhpXFasuA--
X-Mailer: YahooMailClassic/10.1.9 YahooMailWebService/0.8.102.267879
Date: Fri, 23 Apr 2010 09:48:19 -0700 (PDT)
From: Jose Luis Marchetti <joseluismarchetti@yahoo.com.br>
Subject: Suggestions on process integrity checking
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I need to implement a process integrity check, this is to make sure that a process that is running at the time of checking was not corrupted since it was first loaded in memory.
I would appreciate suggestions on where I should implement this in the Linux kernel, my first outline of this work is:

1) Add a field to task_struct that would hold some sort of process digital signature, it could be a CRC32 of process code space, this is not defined yet.
2) For simplicity let us assume an elf file is being executed, in binfmt_elf.c I see the elf file program segments are mmap to the virtual addresses and no read is actually done there ( or am I wrong ?). Where the reading of program segments is actually being done.
3) When the program segments are read in memory I need to update the process digital signature.
4) Then there is the checking part, if the kernel have to perform this checking periodically, how/where do you suggest it to be implemented ?

I was not successful in finding any similar implementation on the Internet that I could base my work on, if you know of any, please let me know.

Thanks in advance for any suggestion.

José Luís Marchetti


      
