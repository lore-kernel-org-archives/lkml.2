Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab0HJCoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 22:44:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52777 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab0HJCog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 22:44:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xHtiYhAkN6EdNqjJny1IxoM4n4xKdx1KH0uxQShb0w0hSocbdE7/nTzbmKoxXSSpL0
         XCVF/qZSIemBCGLONFEr2WCmHcu9Ov9xfceuJ/O+EhPDhhFbFyAYFjASAJxpeg25VDQF
         YkV9yq9goaWMUMhHk0X0JnN3TH1A4pF2irTqY=
MIME-Version: 1.0
In-Reply-To: <AANLkTimU8OCKCaj0b5Ueg__c5DKSKGJWxoZUNK5xeyHk@mail.gmail.com>
References: <AANLkTimU8OCKCaj0b5Ueg__c5DKSKGJWxoZUNK5xeyHk@mail.gmail.com>
Date: Mon, 9 Aug 2010 22:44:35 -0400
Message-ID: <AANLkTimaOiC4eo3Zqn-wO62sV9hVMsNeF-vqkMGi6kVR@mail.gmail.com>
Subject: Re: is nfsd sync or async?
From: Yuehai Xu <yuehaixu@gmail.com>
To: linux-nfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, green.trace@gmail.com, yuehai.xu@gmail.com,
        yhxu@wayne.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 9, 2010 at 8:00 AM, Yuehai Xu <yuehaixu@gmail.com> wrote:
> Hi all,
>
> Suppose there is only one nfsd and two clients are sending random read
> requests to this daemon. In this way, read ahead of the client should
> not work since the requests are random. The requests between these two
> clients should be async, while the requests from any one client of the
> two should be sync. My question is about how will the nfsd handle
> these requests, using sync or async mode in the kernel? Say, will nfsd
> never handle the next request unless the previous request has been
> served, without considering which clients the request belongs to? Or
> nfsd just dispatch async requests to the lower level as soon as it
> receives a request?
>
> Any answer will be appreciate!
>
> Yuehai
>

I review the code of NFS and notice that the read operation of NFS
will invoke generic_file_aio_read(), which means the requests(from the
case I mentioned above) dispatched by a nfsd should be sync to each
other, is that correct?

Thanks,
Yuehai
