Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab0DTXcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 19:32:31 -0400
Received: from mail.agmk.net ([91.192.224.71]:39853 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481Ab0DTXca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 19:32:30 -0400
X-Greylist: delayed 1614 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2010 19:32:30 EDT
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: libc-help@sourceware.org, linux-kernel@vger.kernel.org
Subject: mprotect() failed: Cannot allocate memory
Date: Wed, 21 Apr 2010 01:05:20 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.33.2-1; KDE/4.4.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004210105.20942.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

i'm trying to debug an ugly application with ElectricFence.
in fact, on x86-64 box with 8GB ram and 16GB swap i'm getting following error:

"ElectricFence Exiting: mprotect() failed: Cannot allocate memory"

the program has been compiled with gcc-4.5, glibc-2.11.1, kernel-2.6.32.
did you ever come across such (kernel/glibc) limitations?

here's a simple testcase which triggs -ENOMEM in mprotect().

#define N 100
#include<stdlib.h>

double **bm;
int main(){
    int i;
    long NN = 4*N*N;
    int kmax=100;

        bm = (double **)malloc((time_t)NN*sizeof(double *));
        for(i=0; i<NN; ++i){
                bm[i] = (double*)malloc((time_t)kmax*sizeof(double));
        }

        for(i=0; i<NN; ++i){
                free(bm[i]);
        }
        free(bm);
        return 0;
}

thanks for any hint,

BR,
Pawel.
