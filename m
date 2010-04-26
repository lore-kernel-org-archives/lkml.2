Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab0DZSpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 14:45:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab0DZSpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 14:45:13 -0400
Date: Mon, 26 Apr 2010 15:45:10 -0300
From: Glauber Costa <glommer@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH 1/6] Enable pvclock flags in vcpu_time_info structure
Message-ID: <20100426184510.GF16166@mothafucka.localdomain>
References: <1272303988-21929-1-git-send-email-glommer@redhat.com>
 <1272303988-21929-2-git-send-email-glommer@redhat.com>
 <4BD5D76D.9020601@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD5D76D.9020601@goop.org>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 11:11:57AM -0700, Jeremy Fitzhardinge wrote:
> On 04/26/2010 10:46 AM, Glauber Costa wrote:
> > This patch removes one padding byte and transform it into a flags
> > field. New versions of guests using pvclock will query these flags
> > upon each read.
> >   
> 
> Is this necessary?  Why not just make the pvclock driver maintain a
> local flag set, and have the HV backend call into it to update it.  Why
> does it need to be part of the pvclock structure?
Because it is already there, and we have plenty of space left?

There are obvious other ways, but I don't see any of them being simpler.
If we go by the method you suggested, we'd have, for instance, to register
the memory area where this flags lives. Which is a duplication of the
infrastructure already present in kvmclock.


