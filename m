Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab0JRTMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:12:20 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42615 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab0JRTMT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:12:19 -0400
Date: Mon, 18 Oct 2010 17:12:10 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
        linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        steven miao <realmz6@gmail.com>
Subject: Re: [PATCH] bluetooth: fix unaligned access to l2cap conf data
Message-ID: <20101018191209.GE2468@vigoh>
References: <1287268187-9628-1-git-send-email-vapier@gentoo.org>
 <AANLkTinMSbhTkH0zQn_YO7hFF7zkuv-Gj-B0BUFWy5nP@mail.gmail.com>
 <20101018163223.GC2468@vigoh>
 <AANLkTin3Tx8jyR47G3SNbP_zFJ+tGdR6FtraHmM2T79j@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTin3Tx8jyR47G3SNbP_zFJ+tGdR6FtraHmM2T79j@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Frysinger <vapier@gentoo.org> [2010-10-18 15:10:36 -0400]:

> On Mon, Oct 18, 2010 at 12:32, Gustavo F. Padovan wrote:
> > * Harvey Harrison <harvey.harrison@gmail.com> [2010-10-18 11:17:28 -0700]:
> >> On Sat, Oct 16, 2010 at 3:29 PM, Mike Frysinger <vapier@gentoo.org> wrote:
> >> > From: steven miao <realmz6@gmail.com>
> >> >
> >> >        case 2:
> >> > -               *((__le16 *) opt->val) = cpu_to_le16(val);
> >> > +               put_unaligned_le16(cpu_to_le16(val), opt->val);
> >> >                break;
> >>
> >> I think you wanted:
> >> put_unaligned_le16(val, opt->val);
> >
> > I fixed that in the tree. Thanks for the report.
> 
> i guess you fixed the 32bit one too ?
>   put_unaligned_le32(cpu_to_le32(val), opt->val);

Yes, I did.

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
