Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab2A0Ba5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 20:30:57 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60698 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2A0Ba4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 20:30:56 -0500
MIME-Version: 1.0
In-Reply-To: <20120127010838.GA27899@suse.de>
References: <CAFLxGvw85fWdsAodBn1Z0vFYZx0U+vYg6hgsBYbmfuyaFTgznA@mail.gmail.com>
 <58311.79.160.186.248.1327615864.squirrel@www.nlc.no> <CAFLxGvzsg71gtyPEtOAVnS-DtozYzqgoGNK-ZJRvBfq1mf3Oug@mail.gmail.com>
 <CAFLxGvzffs=uSjxogdWtk_gqoJHPnmgQSLw9WaZRr_be=J5cgw@mail.gmail.com> <20120127010838.GA27899@suse.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 27 Jan 2012 02:30:33 +0100
Message-ID: <CAPXgP12Bj1K3j5HL1=GTj=xEC+oWgB7VFeQL_Pg23fCevTQAcw@mail.gmail.com>
Subject: Re: [uml-devel] /sys/class/tty/tty0/active?
To: Greg KH <gregkh@suse.de>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>, stian@nixia.no,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 02:08, Greg KH <gregkh@suse.de> wrote:
> On Thu, Jan 26, 2012 at 11:56:50PM +0100, richard -rw- weinberger wrote:
>> On Thu, Jan 26, 2012 at 11:12 PM, richard -rw- weinberger
>> <richard.weinberger@gmail.com> wrote:
>> > On Thu, Jan 26, 2012 at 11:11 PM,  <stian@nixia.no> wrote:
>> >>> Hi!
>> >>>
>> >>> systemd goes nuts on UML.
>> >>> While hunting down all issues I found out that systemd wants to read from
>> >>> /sys/class/tty/tty0/active.
>> >>
>> >> Kernel version?
>> >
>> > Linus' tree as of today.
>>
>> Hmm, fbc92a34 introduced it.
>> But it depends on CONFIG_VT. :-\
>
> Is that a problem for UML somehow?

In general, the "crippled" environments might not really the right
thing too run full-blown user login managers like logind.

The main systemd 'init' will not have any problems with that, but
running logind might not really work out under UML.

Depending how far full-OS support in UML should go, logind should
either not run inside UML, or if, UML should provide the needed bits
for in virtual consoles.

If it is not to be solved otherwise, maybe logind needs more
VT-avoiding logic like this:
  http://cgit.freedesktop.org/systemd/systemd/commit/?id=addedec48ba0ffc4472ef6d3b5a45c9d4239f1cd

Kay
