Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab0K2Vh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 16:37:59 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57655 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab0K2Vh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 16:37:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=skTP5Ot9lF7/ueOrQ1SfG8h3wYzrAC4TyaJGASWj7jPSAs6ohUWaQK+6IFpjvItsdn
         v+Pf5JEgX9mqssf+N/Q2HtqHCl5M+YBtP0ZiDBdbFAKyuk9db1zfeVKDbMujaBaEdDzM
         FRccm/gUqZytyZL91WF7BXrEzHVD2Q+XSGDl8=
MIME-Version: 1.0
In-Reply-To: <AANLkTikH+GnpJCjYvn2+LDV30=kNMwNfkA94z+GRpJHG@mail.gmail.com>
References: <20101122191547.GC4340@kroah.com>
	<19695.48938.271140.613069@wylie.me.uk>
	<4CF036CF.20606@goop.org>
	<AANLkTikH+GnpJCjYvn2+LDV30=kNMwNfkA94z+GRpJHG@mail.gmail.com>
Date: Mon, 29 Nov 2010 13:37:56 -0800
Message-ID: <AANLkTikFaxnO3_xYWGGW9gEA6XPVM0pMpMqz-hpEHN_6@mail.gmail.com>
Subject: Re: Xen domU kernel no longer shuts down (Was Linux 2.6.32.26)
From: Alok Kataria <alokkataria1@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Alan J. Wylie" <alan@wylie.me.uk>, Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sander Eikelenboom <linux@eikelenboom.it>, akataria@vmware.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resending my reply, apologies if you get it twice]

On Mon, Nov 29, 2010 at 1:35 PM, Alok Kataria <alokkataria1@gmail.com> wrote:
>
>
> On Fri, Nov 26, 2010 at 2:38 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>
>> On 11/26/2010 06:07 AM, Alan J. Wylie wrote:
>> > Greg KH <gregkh@suse.de> writes:
>> >
>> >> I'm announcing the release of the 2.6.32.26 kernel.
>> > ...
>> >
>> >> Alok Kataria (1):
>> >>       x86, kexec: Make sure to stop all CPUs before exiting the kernel
>> > This patch (ae832c21a08514fd11d2d1d6e217c8a537764bb0) stops my Xen DomU from
>> > shutting down iff vcpus in the xen config file is > 1.
>> >
>> > Simply reverting the commit gets things working properly again.
>>
>> Thanks for confirming this.  I had seen the same thing and suspected
>> this change, but hadn't investigated it yet.
>
>
> To get the old behavior back for Xen you can replace this call
> smp_call_function(stop_self, NULL, wait);
>
>  in  xen_stop_other_cpus with
>
> smp_call_function(stop_self, NULL, 0);
>
> That should fix your hang and fallback to the original behavior, though please note that there might still be a fundamental problem about why some of the AP's don't respond to stop_send IPI on XEN.
>
> Alok
