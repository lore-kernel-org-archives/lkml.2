Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab0ESPdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:33:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63442 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab0ESPdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:33:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eo6OY56gtB08O1S5ry7I3hlAucB5MqZ1h7bqL7cs+urp68OwlrY7Sei5j7dGb2se+7
         IWHCF++5JfFDeDCYA3oizU2sKJhl8RquKX+FpjCNilXQrdsEwS+3vnodxCQE2oIQXi+S
         uzEXdX5XhmWxDoxIjqIG7QwXlFihLEBIQgBnA=
Subject: Re: More than 1M open file descriptors
From: Eric Dumazet <eric.dumazet@gmail.com>
To: John Masinter <johnmasinter@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTim5Yuvga5kwOFUaUgxbxzvkD9gyqiEUCN6nTs5b@mail.gmail.com>
References: <AANLkTim5Yuvga5kwOFUaUgxbxzvkD9gyqiEUCN6nTs5b@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 17:26:03 +0200
Message-ID: <1274282763.2766.120.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 19 mai 2010 à 10:52 -0400, John Masinter a écrit :
> I'm a software engineer and work with a fortune-500 company. We have a
> line of linux-powered network security appliances and I am responsible
> for Linux / OS development.
> Our multi-core appliance handles a large number of low-bandwith tcp
> connections, and after years of performance streamlining, we have hit
> the kernel's million tcp connection limit.
> Is there a kernel hack to increase the file descriptor limit beyond 1M
> to that we may have more than 1M open tcp connections? If this is
> discussed elsewhere, please point me in the right direction. Many
> thanks to everyone that contributes to open source.
> --

Its not a problem with a recent kernel (2.6.25)

commit 9cfe015aa424b3c003baba3841a60dd9b5ad319b
Author: Eric Dumazet <dada1@cosmosbay.com>
Date:   Wed Feb 6 01:37:16 2008 -0800

    get rid of NR_OPEN and introduce a sysctl_nr_open
    
    NR_OPEN (historically set to 1024*1024) actually forbids processes to open
    more than 1024*1024 handles.
    
    Unfortunatly some production servers hit the not so 'ridiculously high
    value' of 1024*1024 file descriptors per process.
    
    Changing NR_OPEN is not considered safe because of vmalloc space potential
    exhaust.
    
    This patch introduces a new sysctl (/proc/sys/fs/nr_open) wich defaults to
    1024*1024, so that admins can decide to change this limit if their workload
    needs it.
    


