Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab3AFXKn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 18:10:43 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:59800 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab3AFXKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 18:10:40 -0500
Date: Mon, 7 Jan 2013 00:09:47 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: federico.vaga@gmail.com
Cc: mchehab@redhat.com, m.szyprowski@samsung.com, mchehab@infradead.org,
        pawel@osciak.com, hans.verkuil@cisco.com, giancarlo.asnaghi@st.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        corbet@lwn.net, s.nawrocki@samsung.com
Subject: Re: [PATCH v3 2/4] videobuf2-dma-streaming: new videobuf2 memory
 allocator
Message-ID: <20130106230947.GA17979@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <3892735.vLSnhhCRFi@harkonnen>
References: <3892735.vLSnhhCRFi@harkonnen>
  <1348484332-8106-1-git-send-email-federico.vaga@gmail.com>
 <1399400.izKZgEHXnP@harkonnen> <12929800.xFTBAueAE0@harkonnen>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem is that on the sta2x11 architecture only the first 
> 512MB are available through the PCI bus, but the allocator can allocate memory 
> for DMA above this limit. By using GFP_DMA flags the allocation take place 
> under the 16MB so it works.

Still, you are not running the upstream allocator.  IIUC, you added a
"gfp_t" field in the platform data or somewhere, so the sta2x11 can
request GFP_DMA to be OR'd, while other users remain unaffected.  Will
you please submit the patch to achieve that?

> I cannot do performance test at the moment because I don't have the time, so I 
> cannot personally justify the presence of a new allocator.

I don't expect you'll see serious performance differences on the PC. I
think ARM users will have better benefits, due to the different cache
architecture.  You told me Jon measured meaningful figures on a Marvel
CPU.

> I will propose V4 patches soon.

thanks
/alessandro
