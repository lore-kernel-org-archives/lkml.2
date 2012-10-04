Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab2JDUO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 16:14:58 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35993 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab2JDUOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 16:14:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo48XLzLvziACEi+0nWuRXurHCLnw+iwgqu8-BRutjNtWw@mail.gmail.com>
References: <CAE9FiQWgvVqnTTeYFvxf1GxLcEEeRyN-uSKPdg3o69oCpm43sQ@mail.gmail.com>
	<1349305214-3241-1-git-send-email-yinghai@kernel.org>
	<20121004174746.GA24119@google.com>
	<CAE9FiQWDnrk7VccFLLHucCVSxN5RRS0-8pwYazLy2aw3oqmPLQ@mail.gmail.com>
	<CAErSpo48XLzLvziACEi+0nWuRXurHCLnw+iwgqu8-BRutjNtWw@mail.gmail.com>
Date: Thu, 4 Oct 2012 13:14:52 -0700
X-Google-Sender-Auth: v75NB6GqSTJKxp2sloMYM3Py5_k
Message-ID: <CAE9FiQVyx5EL8RCuHF5rOoT5Zj7ksnAFJgg09hGE_sHfRJJXpw@mail.gmail.com>
Subject: Re: [PATCH 0/4] ACPI: kill acpi_pci_root_start
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Len Brown <lenb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 12:44 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> To answer your specific question, yes, I do think drivers that are
> statically built in probably should be registered before devices are
> enumerated.  That way, the boot-time case is more similar to the
> hot-add case.
>
> Obviously, for drivers that can be modules, the reverse must work as
> well (enumerate devices, then load and register the driver).  And then
> the other order (register driver, then enumerate device) must also
> work so future hot-adds of the same device type work.

so you will have to handle two paths instead one.

current booting path sequence are tested more than hot add path.
