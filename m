Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab2GOIDW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 04:03:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab2GOIDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 04:03:10 -0400
Message-ID: <50027937.60803@redhat.com>
Date: Sun, 15 Jul 2012 11:03:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: sheng qiu <herbert1984106@gmail.com>
CC: kvm <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: lots of APIC_TMICT exit on VM with assigned NIC
References: <CAB7xdinLSMBFtNa2sLBvNKE0H7cmfOr05+jVStd63MS5maP9VQ@mail.gmail.com> <4FFE8FEB.2020606@redhat.com> <CAB7xdinaGFxyn3OHmsq0Lqtkfs9XST0j0Tj4kBvQGNf5UxWLvw@mail.gmail.com>
In-Reply-To: <CAB7xdinaGFxyn3OHmsq0Lqtkfs9XST0j0Tj4kBvQGNf5UxWLvw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2012 08:32 PM, sheng qiu wrote:
> thanks for your reply.
> the value is very large. 

Can you provide samples?

If it's large and fairly constant it means a timer keeps being pushed
back by the interrupts/


> is there anyway that i  can avoid such
> frequent exits due to APIC_TMICT? do i need to modify some codes in
> kvm kernel module or adapt some parameters?
> 

No, a guest change is needed.  You need to find out what timer is
involved at modify it to set some slack, with
hrtimer_set_expires_range() or similar.
-- 
error compiling committee.c: too many arguments to function


