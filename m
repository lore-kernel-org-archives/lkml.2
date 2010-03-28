Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab0C1T2Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 15:28:24 -0400
Received: from smtp1.rdslink.ro ([81.196.12.70]:49305 "EHLO smtp.rdslink.ro"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755050Ab0C1T2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 15:28:18 -0400
X-Mail-Scanner: Scanned by qSheff-II-2.1-r3 (http://www.enderunix.org/qsheff/)
Subject: Checkpatch.pl false positive? "ERROR: return is not a function,
 parentheses are not required"
From: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
To: apw@canonical.com, akpm@linux-foundation.org, dwalker@fifo99.com,
       joe@perches.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Sun, 28 Mar 2010 22:28:13 +0300
Message-ID: <1269804493.7079.14.camel@tuxtm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've used checkpatch.pl to verify drivers/staging/dt3155/dt3155_isr.c,
in order to provide a patch which fixes the errors and warnings found by
checkpatch.
The script returns the following error:
ERROR: return is not a function, parentheses are not required
#155: FILE: staging/dt3155/dt3155_isr.c:155:
+  return (dt3155_fbuffer[m]->ready_head -

The original code is:

  return (dt3155_fbuffer[m]->ready_head -
           dt3155_fbuffer[m]->ready_len +
           dt3155_fbuffer[m]->nbuffers)%
          (dt3155_fbuffer[m]->nbuffers);

I've deleted the the first open parenthesis and the last close
parenthesis, and now the code looks like this:

  return (dt3155_fbuffer[m]->ready_head -
           dt3155_fbuffer[m]->ready_len +
           dt3155_fbuffer[m]->nbuffers)%
          (dt3155_fbuffer[m]->nbuffers);

IMHO the code is correct, though an auxiliary variable could be used to
avoid this error returned by checkpatch.pl. 

Regards,
Olimpiu Pascariu




