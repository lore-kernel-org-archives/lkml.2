Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab2GZKoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:44:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab2GZKoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:44:02 -0400
Message-ID: <50111F6C.7010502@redhat.com>
Date: Thu, 26 Jul 2012 12:43:56 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] virtio-scsi: fix parsing of hotplug/hot-unplug LUN
 number
References: <1342454751-8950-1-git-send-email-pbonzini@redhat.com>    <1342454751-8950-2-git-send-email-pbonzini@redhat.com>   <1343292731.3115.17.camel@dabdike> <50110820.4040403@redhat.com>  <1343294472.3115.22.camel@dabdike> <50111936.8090508@acm.org> <1343298798.3115.31.camel@dabdike>
In-Reply-To: <1343298798.3115.31.camel@dabdike>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 26/07/2012 12:33, James Bottomley ha scritto:
>> > Has it already been considered to modify scsilun_to_int() such that LUN
>> > numbers start at zero even for addressing method 1 ? This is what e.g.
>> > the function scst_unpack_lun() already does. See also
>> > http://scst.svn.sourceforge.net/viewvc/scst/trunk/scst/src/scst_lib.c?revision=HEAD&view=markup.
> Yes, as I said before, the problem is that the actual numbers are
> 
> 1. not 1:1: there are several possible encodings of luns 0-255
> 2. hierarchical, so once you go beyond a single level you can't properly
> use a numeric representation either.
> 
> the mid layer just uses the lun number as an encoding of the actual SAM
> lun.  The key for us is that int_to_scsilun has to go back the other
> way.

I still disagree, but I will modify QEMU so that this patch is not
necessary.  Later I can switch to int_to_scsilun.

Paolo

