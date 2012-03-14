Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761035Ab2CNNLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 09:11:40 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47920 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018Ab2CNNLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 09:11:39 -0400
MIME-Version: 1.0
Date: Wed, 14 Mar 2012 18:41:37 +0530
Message-ID: <CAJ8eaTxpHUrSYJYA=ph49tb02UQt9+NPL85pmqmi1btJ4LJSEA@mail.gmail.com>
Subject: kernel 3.0.22 ARM unaligned access issue
From: naveen yadav <yad.naveen@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am running one simple program, unaligned access on ARM cortex A9 on
3.0.22 kernel.
CONFIG_DISABLE_UNALIGNED_ACCESS=y
CONFIG_ALIGNMENT_TRAP=y
But I am surprise that program run well,and control does not come to
do_alignment(). for user fault.
what may be reason ?
Test Code:
#include<stdio.h>
#include<malloc.h>
    int main ( )
    {
        char *data;
        short *sp1, *sp2;
        int *ip;
        data = (char *)malloc(16);;
        sp1 = (short*)(data+3);
        sp2 = (short*)(data+5);
        ip = (int*)(data+7);
        *sp1=10;
        *sp2=20;
        *ip=30;
        fprintf(stderr, "%d %d %d\n", *sp1, *sp2, *ip);
        return 0;
    }

on kernel 3.0.22
./a.out
10 20 30
