Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab0CSWqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 18:46:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37478 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab0CSWqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 18:46:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=nJfiRt1fOy4uzScHfznKfI0By8DsOCN9T9wXBkWIuQNLr5jFoTiezCZ/J8bbQ/htL/
         N+mb3s64cxtp47LkBi5bmMohqS8PLx72zdCMOmxbNKYkuDm4c6OFP+II7jvNnhjBnB88
         XKyT9itT12rJmDLk9zQNWjVz655v1Rq7lmv1I=
MIME-Version: 1.0
In-Reply-To: <4BA3FD3E.9070801@gmail.com>
References: <4BA3FD3E.9070801@gmail.com>
Date: Fri, 19 Mar 2010 18:46:49 -0400
X-Google-Sender-Auth: 9d0545d7ffe8d2cc
Message-ID: <87d699441003191546v6c0f0b89t64ab93c4e3207f37@mail.gmail.com>
Subject: Re: Intel SASMF8I
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Marco Schindler <marco.schindler@gmail.com>
Cc: Eric.Moore@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 6:39 PM, Marco Schindler
<marco.schindler@gmail.com> wrote:
> Hello,
> this card (using LSISAS1068(E)) is not recognized by FUSION_SAS, after
> patching the device code it appears to work nicely.
>

I was 99% of the way there to submit a similar patch (actually there's
a few more places where you want to add the new ID), but noticed a
previous discussion when a comparable patch was rejected. Turns out
there was a jumper on my motherboard (Supermicro X8DT3) which switches
between "raid" and "regular" mode (except they were called something
much fancier), and the regular mode switches the PCI ID to 0x58 which
in turn is recognized. [And the mptsas driver doesn't support the RAID
features anyways... there's a what appears to be proprietary driver
for that, megasr, which I did not need.]
