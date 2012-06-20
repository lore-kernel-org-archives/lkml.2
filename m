Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab2FTAdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 20:33:22 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41293 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab2FTAdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 20:33:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAB7xdik9-U_4ODdcGTfhPg+Ma2rZ11Q9ixnW-uH6AoORj=Zvwg@mail.gmail.com>
References: <CAB7xdik9-U_4ODdcGTfhPg+Ma2rZ11Q9ixnW-uH6AoORj=Zvwg@mail.gmail.com>
Date: Tue, 19 Jun 2012 19:33:19 -0500
Message-ID: <CAB15OBd49MjiuMp9fi-noxmqkhMkGaRQ4N7WVhTwc79V2S9+Yg@mail.gmail.com>
Subject: Re: how to map a host virtual address (hva) to guest address space (gva/gpa/gfn)
From: Mehul Chadha <mehulc87@gmail.com>
To: sheng qiu <herbert1984106@gmail.com>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 6:09 PM, sheng qiu <herbert1984106@gmail.com> wrote:
> Hi all,
>
> is there any existing function in KVM that can map a host virtual
> address (hva) to the guest address space. So that the guest VM can
> access it.
> i.e. translate hva to a gpa or gva or gfn, so the guest VM can use
> that converted address to access?
I am not aware of a function that exists in kvm, but you can write one using
__gfn_to_memslot()  as a reference implementation.

you can check if the hva falls in a particular memslot using
userspace_addr member
of the memslot structure, and then calculate the corresponding gfn from that.
>
> Thanks,
> Sheng
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
