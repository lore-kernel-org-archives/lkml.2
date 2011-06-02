Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab1FBRam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 13:30:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61331 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab1FBRal convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 13:30:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LzKL9J6t5liYrVJNcBNiryM+KnMhrRp1t//oMFzh0vROxgJ7y9e3g2ZFIoAc4J7N8v
         EmBvPhDVJsKtCNclTd/GqTf/jZY8jUJ0ylGF4m2lwUKSrtXnLLQEcW6jSNoUmKb03Ewv
         0X7gjRZWQ29U+TnVka1NOM+FD03FlggSAna3c=
MIME-Version: 1.0
In-Reply-To: <201103122218.14832.rjw@sisk.pl>
References: <201103100131.58206.rjw@sisk.pl>
	<201103122212.40828.rjw@sisk.pl>
	<201103122218.14832.rjw@sisk.pl>
Date: Thu, 2 Jun 2011 10:30:40 -0700
X-Google-Sender-Auth: t242rZESHRyS8gH5fkTdUF25Gs0
Message-ID: <BANLkTi=xhg7_0O-aVC8s1Uyo4Wkz5OTCdg@mail.gmail.com>
Subject: Re: [PATCH 5/8] PCI / Intel IOMMU: Use syscore_ops instead of sysdev
 class and sysdev
From: Tony Luck <tony.luck@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de,
        Dave Jones <davej@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 12, 2011 at 1:18 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> -static int __init init_iommu_sysfs(void)
> -{
> -       return 0;
> -}
> +static inline int init_iommu_pm_ops(void) { }
>  #endif /* CONFIG_PM */

drivers/pci/intel-iommu.c:3391: warning: no return statement in
function returning non-void

s/static inline int/static inline void/

Reported-by: Tony Luck <tony.luck@intel.com>

-Tony
