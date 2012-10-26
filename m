Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab2JZDMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 23:12:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60170 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab2JZDMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 23:12:20 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwaLnyYFaydxw1ALmp_EP217DmgY=ihNy3z1ZqF-pqkSA@mail.gmail.com>
References: <1351212379-26026-1-git-send-email-ming.lei@canonical.com>
	<CA+55aFwaLnyYFaydxw1ALmp_EP217DmgY=ihNy3z1ZqF-pqkSA@mail.gmail.com>
Date: Fri, 26 Oct 2012 11:12:18 +0800
Message-ID: <CACVXFVObmYD9iG1yMkCNqfdx-XxMKOJ41kAROyxx-RBDufKKmQ@mail.gmail.com>
Subject: Re: [PATCH v1] firmware loader: introduce module parameter to
 customize fw search path
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 10:32 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Please just make "fw_path[0]" just be the pointer to fw_path_para[]
> (which sounds like the cleanest fix) and get rid of the negative 'i'
> and conditional entirely.

Yes, it should be the cleanest, I don't do it because I thought that might
have caused one compile warning('const char *' points to memory
without 'const', like below)

	static char fw_path_para[256];
	static const char *fw_path[] = {
		fw_path_para,
		"/lib/firmware/updates/" UTS_RELEASE,
		"/lib/firmware/updates",
		"/lib/firmware/" UTS_RELEASE,
		"/lib/firmware"
	};

but in fact there isn't any warning with above change and it does work, still
don't know why? :-(

Thanks,
--
Ming Lei
