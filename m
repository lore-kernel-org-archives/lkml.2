Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab2AWWif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 17:38:35 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38424 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab2AWWid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 17:38:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQW5VZZrdQmuKF6_4dvTDUO9xPL=uqo0KaohnJ4xboDwSA@mail.gmail.com>
References: <1327139539-14301-1-git-send-email-yinghai@kernel.org>
 <1327139539-14301-2-git-send-email-yinghai@kernel.org> <CA+55aFz7B5ebEGKKJmvuWY+2O-6qarUj40CHASu_4EQ0KDgi_Q@mail.gmail.com>
 <CAE9FiQWbmO+FFsE06eQ=-PVNtdaTG3EsqXNXdUCxb9YxtPS8Cw@mail.gmail.com>
 <CA+55aFyok04YrmEYXLbAE2vB_944+aEJZhd5tzu6U2k0CLaN5A@mail.gmail.com>
 <CAE9FiQXDHHJ0rG6hd6a3B+f0ZyJmjJ3rJGNWTsCwn21o+84C_Q@mail.gmail.com>
 <CA+55aFy4nv5bYdjiZM2HY1E=RU_CaBoQWy6iWXReAK98yRKZpw@mail.gmail.com>
 <CAE9FiQWt7j+Eoo_xhFmaGGh7hA-j2x991KZajmberf8Kod5G1g@mail.gmail.com> <CAE9FiQW5VZZrdQmuKF6_4dvTDUO9xPL=uqo0KaohnJ4xboDwSA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jan 2012 14:38:12 -0800
X-Google-Sender-Auth: 6uKXv9dFlVSf45IYf4wBVHZAYCc
Message-ID: <CA+55aFxBKbXSNmfs8y6SrzA8w3kVRRni9R6VjxSJ-5VsRyhX0g@mail.gmail.com>
Subject: Re: [PATCH 1/7] PCI: Make sriov work with hotplug remove
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 2:30 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> for_each_prev_safe is working...
>
> please check attached patch...

Ugh. This is probably the best one so far, but the whole thing is
really confused.

Why does "stop_bus_device" do a "remove" for VF's at _all_? Why is
everything about those stupid virtual devices so screwed up? Why do we
have separate "stop" and "remove" methods, and then the "stop" does a
remove? WTF?

                         Linus
