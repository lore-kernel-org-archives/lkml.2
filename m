Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab1CQFXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 01:23:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39345 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1CQFXe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 01:23:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fziraKiHU8kJ5jrNd7/CtQwwgPT+KDlqVf9c4KC9LaNrixsz01yx3Lgf5+FGHKpAif
         EHZXR/FrTpMQj9WBFUitB46q3+RGL5XraRE38DHMvBxHQNRwlK05iKvhhWHH7OlpANKk
         KHlGVF3oqnreAHT7PsZVZueXc2bhPAiJuDRVU=
MIME-Version: 1.0
In-Reply-To: <201103170119.17647.rjw@sisk.pl>
References: <201103052254.48515.rjw@sisk.pl>
	<201103150100.17501.rjw@sisk.pl>
	<20110315190545.GA4165@xanatos>
	<201103170119.17647.rjw@sisk.pl>
Date: Wed, 16 Mar 2011 22:23:32 -0700
X-Google-Sender-Auth: eWLyjdWwlo0ytLjJIAhNBnYfLA0
Message-ID: <AANLkTim39fjrAp4OW_MfpbZkz-YYW5E2NOHuo1j=svmW@mail.gmail.com>
Subject: Re: [RFT][PATCH] PCI / ACPI: Do not require MSI support for PCIe
 native features
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/16 Rafael J. Wysocki <rjw@sisk.pl>:
> On Tuesday, March 15, 2011, Sarah Sharp wrote:
>> On Tue, Mar 15, 2011 at 01:00:17AM +0100, Rafael J. Wysocki wrote:
>> > Well, I must admit I have no idea what the problem is.  OK, in addition to the
>> > above changes, please replace the "pci_ext_cfg_avail(root->bus->self)" in the
>> > same file with "true" and see if _that_ helps.
>>
>> Yay, that worked!  dmesg is attached.
>
> Good, at least we know what the problem is, now we only have to find the root
> cause. ;-)
>
> So, pci_ext_cfg_avail(root->bus->self) returns 0 on your machine, which is kind
> of unexpected (to put it lightly), so very likely we have uncovered a bug
> in the init code.
>
> Unfortunately, I may not be able to take care of this issue for the next few
> days, I'll let you know when I get back to it.

her .config does not define PCI_MMCONFIG

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set

Yinghai
