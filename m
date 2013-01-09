Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933880Ab3AIVFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:05:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:41580 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933751Ab3AIVFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:05:30 -0500
Message-ID: <1357765188.4838.52.camel@pasglop>
Subject: Re: [PATCH 0/8] PCI, ACPI, x86: Reserve fw allocated resource for
 hot-add root bus
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Michal Simek <monstr@monstr.eu>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Paul Mackerras <paulus@samba.org>
Date: Thu, 10 Jan 2013 07:59:48 +1100
In-Reply-To: <CAErSpo6qX3ih9DXLqxqJw141OAeTFu0YfSih6LyD0sd2gS-Vyg@mail.gmail.com>
References: <20121030040237.GA10472@google.com>
	 <1352003971-22278-1-git-send-email-yinghai@kernel.org>
	 <CAE9FiQUn=bcgOLFzBwsBT1-O1poRNy9qYTb0w9EAya3_inKqAw@mail.gmail.com>
	 <CAErSpo5Z57asEXbfesOjXMEPj4WM3YMbzQH3s-v_NBrnPNmuVQ@mail.gmail.com>
	 <CAErSpo4LS7ShCbeOm1s9ob1MjPfUSWn9J96UHRBP6van54swQA@mail.gmail.com>
	 <CAE9FiQV5x1S1BNHrXq0wMRDx7PD5BoCh3fOnq2vS_AOAGL8Rrw@mail.gmail.com>
	 <CAErSpo5vEb=63jGsqfau1G=f54oqq17pc3ZzcpzhL7hQrtYhng@mail.gmail.com>
	 <CAE9FiQUxxjZmd3C33_ujSeL1EjcKHHSoGusQwfBD+Zd=cwCDZA@mail.gmail.com>
	 <CAErSpo6qX3ih9DXLqxqJw141OAeTFu0YfSih6LyD0sd2gS-Vyg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-09 at 11:39 -0700, Bjorn Helgaas wrote:
> 
> > the reason why we need to change those codes for x86, we want to
> make it support
> > pci root bus hotplug. So it would be reasonable for us to align
> other
> > platform to x86
> > changes after pci root bus hotplug change is completely done.
> 
> OK, I opened https://bugzilla.kernel.org/show_bug.cgi?id=52531 as a
> way to keep track of this consistency issue and merged
> pci/yinghai-survey-resources to my -next branch.

Hrm... that's going to be tricky. For example the SR-IOV stuff will not
work for us, we are working on a different implementation, due to some
of "interesting" bridge constraints etc...

It would be nice to get more of the resource survey in common, our
original code was actually completely different and I reconciled it a
lot with x86 in the past few years, but I'm sure we can do better.
However there are still going to be corner cases....

Ben.


