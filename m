Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab1AFO2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 09:28:40 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40431 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab1AFO2j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 09:28:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oCMLcQrjqWICu0qCVLZqgxi5HJ/GC9LlKsnV4g5gEQkaNG/acIBDp7pMTP6JmPaPbr
         Jc/LsrmRiJ+jqN0sR4wdTu8Xe7KqAetgDItL4iB7ax1a340DL0aM13QBGp3575e4V4kQ
         4FzB+5goOvMuKYJasR/V9jSULjZUkP1+lGZFU=
MIME-Version: 1.0
In-Reply-To: <20110106125412.GB1841@sepie.suse.cz>
References: <AANLkTin01j5oTUdh6fAgs--Gi46BZOWZCdypUPd8uhm4@mail.gmail.com>
	<4CF7BA6D.60002@suse.cz>
	<AANLkTinK9dKnSZdkH57dZNMysg0uVu7DfNtmmZdG8HZD@mail.gmail.com>
	<20110106125412.GB1841@sepie.suse.cz>
Date: Thu, 6 Jan 2011 09:28:38 -0500
Message-ID: <AANLkTinq_1Uq6f--YzR87j-pBVWW0U-1RQS4-KoEQmXn@mail.gmail.com>
Subject: Re: [PATCH] Bug in scripts/package/mkspec?
From: Patrick LeBoutillier <patrick.leboutillier@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal,

Maybe the easiest way is just to rebuild the spec file everytime we do
"make rpm".
I'll try it and see how it does.

Do you know of the .version file is used for anything outside of the
"make rpm" process?

Patrick


On Thu, Jan 6, 2011 at 7:54 AM, Michal Marek <mmarek@suse.cz> wrote:
> On Thu, Dec 02, 2010 at 04:15:20PM -0500, Patrick LeBoutillier wrote:
>> Hi Michal,
>>
>> Sorry for the bad patch. Here is basically what I do:
>>
>> $ make menuconfig
>> $ make rpm
>> ...
>> Wrote: /root/rpmbuild/RPMS/x86_64/kernel-2.6.36.1-1.x86_64.rpm
>> ...
>> $ make menuconfig # tweak some configs
>> $ make rpm
>> ...
>> Wrote: /root/rpmbuild/RPMS/x86_64/kernel-2.6.36.1-1.x86_64.rpm
>> ...
>>
>>
>> My expectation (and perhaps it is incorrect) is that subsequent "make
>> rpm"s on the same build tree
>> yield rpms with increasing release numbers (2.6.36.1-1, 2.6.36.1-2,
>> ...). Is this how it's supposed
>> to work?
>
> I see the problem now, unfortunatelly I haven't yet found a fix. The
> problem is that the .version file is updated during build, but rpm needs
> to know the release number in advance. The fact that there are about
> four places that deal with the .version file is also not helping :-(.
>
> Michal
>



-- 
=====================
Patrick LeBoutillier
Rosemère, Québec, Canada
