Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0EZPEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:04:49 -0400
Received: from monge.univ-mlv.fr ([193.55.63.80]:54505 "EHLO monge.univ-mlv.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab0EZPEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:04:47 -0400
X-Greylist: delayed 1178 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 May 2010 11:04:47 EDT
Message-ID: <4BFD33F0.1060908@univ-mlv.fr>
Date: Wed, 26 May 2010 16:45:04 +0200
From: =?UTF-8?B?U8OpYmFzdGllbiBQYXVtaWVy?= 
	<sebastien.paumier@univ-mlv.fr>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: getpid() returning same value as getppid()
Content-Type: multipart/mixed;
 boundary="------------090906030804020905090502"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090906030804020905090502
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,
here is a bug that occurs on my kernel 2.6.31-21, maybe with older ones. 
  If a C program contains a function with the constructor attribute that 
calls getpid(), then, a call to syscall(SYS_fork) produces a son that 
obtains the same value calling getpid() or getppid().

Best regards,
Sébastien Paumier

--------------090906030804020905090502
Content-Type: text/x-csrc;
 name="test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="test.c"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <sys/types.h>

void foo(void) __attribute__ ((constructor));

void foo(void) {
	/* Removing this call to getpid() removes the bug */
	getpid();
}


int main(void){
	int i=syscall(SYS_fork);
	if (0==i) 
		/* Big problem: the son prints the same value for getpid() and getppid() */
		printf("__son : %d   father : %d__\n", getpid(), getppid());
	else
		printf("<<father : %d   son : %d>>\n", getpid(), i);
	return 0;
}

--------------090906030804020905090502--
