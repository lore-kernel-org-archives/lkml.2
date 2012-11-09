Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab2KIVDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:03:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62577 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab2KIVDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:03:48 -0500
Date: Fri, 9 Nov 2012 22:03:35 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Rob Clark <robdclark@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, linux-tegra@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/2] drm: Add NVIDIA Tegra20 support
Message-ID: <20121109210334.GA9023@avionic-0098.mockup.avionic-design.de>
References: <1352469579-3337-1-git-send-email-thierry.reding@avionic-design.de>
 <1352469579-3337-2-git-send-email-thierry.reding@avionic-design.de>
 <CAF6AEGs4bk3umkbQmJmB+Gf4UctKWa2Rj9GEi=DZSqU8MUd+9w@mail.gmail.com>
 <20121109160002.GA6474@avionic-0098.mockup.avionic-design.de>
 <CAF6AEGu0j1E96tzsTcJ91-FdTekAoWL7w1GBadRQ7p2h0smVDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <CAF6AEGu0j1E96tzsTcJ91-FdTekAoWL7w1GBadRQ7p2h0smVDA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:FpIrymC2HWcQvcwFWcz1MFaPNchwvOLmYca+h+6mCuE
 6y4fYfzlzql/zQULi1v+u4G1FuP8zTrWPxTf+/TkeJEE8zAYV0
 +ap/sK30aCezPBjW74+sIVrU1g7/bpv54trEL3w7n8Ttcyk05L
 eUlsGZVlfFPX074lUMqMJApZTPrLDO64COT0q2xfEy2Fu2vb+O
 wI8YRhI/xf44XdJKGRB1TaWM26jhgK9gz9zINTi6X+/jn1ul8g
 W2b1/VTW5t2asJyP7oCcD2rKEqCHysXbVddp1LKxkgWcvkxgbU
 cnMKDiQ1ucLp9wc9OBiSKKbVTfVxLM7NzD2ezdHnet25G9UFda
 wEt+u+0Fh2K1hkWtwDXzwd3xvWmuXSYYbuUqesHvVUB4VCtndf
 x7ohwqmXBnRynJflCNDDJxhr1bCWI30cTyQFOaId6ulx7ISjkd
 XTg/y
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 09, 2012 at 10:26:27AM -0600, Rob Clark wrote:
> On Fri, Nov 9, 2012 at 10:00 AM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> > On Fri, Nov 09, 2012 at 09:18:58AM -0600, Rob Clark wrote:
> >> On Fri, Nov 9, 2012 at 7:59 AM, Thierry Reding
> >> <thierry.reding@avionic-design.de> wrote:
> > [...]
> >> > +static int regs_open(struct inode *inode, struct file *file)
> >> > +{
> >> > +       return single_open(file, regs_show, inode->i_private);
> >> > +}
> >> > +
> >> > +static const struct file_operations regs_fops =3D {
> >> > +       .open =3D regs_open,
> >> > +       .read =3D seq_read,
> >> > +       .llseek =3D seq_lseek,
> >> > +       .release =3D single_release,
> >> > +};
> >> > +
> >> > +static int tegra_dc_debugfs_init(struct tegra_dc *dc, struct dentry=
 *parent)
> >> > +{
> >> > +       char *name;
> >> > +
> >> > +       name =3D kasprintf(GFP_KERNEL, "dc.%d", dc->pipe);
> >> > +       dc->debugfs =3D debugfs_create_dir(name, parent);
> >> > +       kfree(name);
> >> > +
> >> > +       debugfs_create_file("regs", 0400, dc->debugfs, dc, &regs_fop=
s);
> >> > +
> >>
> >> note that drm already has it's own debugfs helpers, see
> >> drm_debugfs_create_files() and drm_debugfs_remove_files()
> >>
> >> And also see debugfs_init/debugfs_cleanup in 'struct drm_driver'.
> >>
> >> You probably want to be using that rather than rolling your own.  You
> >> can have a look at omapdrm for a quite simple example, or i915 for a
> >> more complex example.
> >
> > I actually tried to make use of those functions, but unfortunately it's
> > not possible to hook it up properly. The reason is that I need to pass
> > in some reference to the tegra_dc structure in order to read the
> > registers, but the DRM debugfs support doesn't allow to do that. Or
> > maybe it can. There's the void *arg argument that I could possibly use.
> > Then again it won't allow the creation of separate directories for each
> > of the display controllers. Or maybe I'm missing something.
>=20
> yeah, no separate directories.. but you could use the void *arg.

Actually, the drm_debugfs_create_files() takes a root parameter, which
could be used to create subdirectories. I think there may be a problem
with the cleanup path because creating subdirectories means that the
call to drm_debugfs_cleanup() won't be able to remove the top-level
directory of the drm_minor as it won't be empty. That should be fixable
by replacing the debugfs_remove() call by debugfs_remove_recursive().
I'll try to implement the debugfs code in terms of what the DRM core
provides and see how it works out.

> It is a bit awkward for dealing with multiple subdevices, we have the
> same issue w/ omapdrm where dmm is a separate subdevice (and
> dsi/dpi/hdmi/etc too shortly, as we merge omapdss and omapdrm).
>=20
> But I guess better handling in drm for subdevices would help a lot of
> the SoC platforms.  Maybe something that I'll give some more thought
> later after the atomic pageflip/modeset stuff is sorted.

Right. I initially thought that it might be nice if drivers could
dynamically add CRTCs and encoders/connectors. Since I'm rather new to
this whole DRM business I didn't feel comfortable, so I decided to go
with what was there already. However I think that there's a lot of
potential for improvements, especially in the area of embedded devices.
But it's definitely something that we can do incrementally.

> >> > +/* synchronization points */
> >> > +#define SYNCPT_VBLANK0 26
> >> > +#define SYNCPT_VBLANK1 27
> >>
> >> maybe these should be in dc.h?  Seems like these are related to the dc=
 hw block?
> >
> > Yes, they could go into dc.h. This is one of the things that is likely
> > to change at some point as more of the host1x support is added, which is
> > where those syncpts are actually used.
>=20
> hmm, are these values defined by the hw?  They look like register
> offsets into the DC block?

I don't think they are defined by the hardware. From what I gather these
can arbitrarily be assigned by software. If things actually work the way
I think they do, then eventually these values could be allocated by the
host1x_register_client() function and stored within the host1x_client
structure, so that each HW block can program them into the corresponding
register.

Again, for now this is not very important as there are no HW blocks that
need synchronization. However it will become necessary once the basic 2D
acceleration is implemented on top of this driver.

> >> > +int host1x_unregister_client(struct host1x *host1x,
> >> > +                            struct host1x_client *client)
> >> > +{
> >> > +       struct host1x_drm_client *drm, *tmp;
> >> > +       int err;
> >> > +
> >> > +       list_for_each_entry_safe(drm, tmp, &host1x->drm_active, list=
) {
> >> > +               if (drm->client =3D=3D client) {
> >> > +                       err =3D host1x_drm_exit(host1x);
> >> > +                       if (err < 0) {
> >> > +                               dev_err(host1x->dev, "host1x_drm_exi=
t(): %d\n",
> >> > +                                       err);
> >> > +                               return err;
> >> > +                       }
> >> > +
> >> > +                       host1x_remove_drm_client(host1x, drm);
> >> > +                       break;
> >> > +               }
> >> > +       }
> >> > +
> >> > +       mutex_lock(&host1x->clients_lock);
> >> > +       list_del_init(&client->list);
> >> > +       mutex_unlock(&host1x->clients_lock);
> >> > +
> >> > +       return 0;
> >> > +}
> >>
> >> btw, if I understand the register/unregister client stuff, I think
> >> there can be some potential issues.  If I understand correctly, you
> >> will create the crtc's in register.  But unregister doesn't destroy
> >> them, drm_mode_config_cleanup() when the container drm device is
> >> unloaded does.  So if there is any possibility to unregister a client
> >> without tearing down everything, you might get into some problems
> >> here.
> >>
> >> Also, you might be breaking some assumptions about when the crtc's are
> >> created.. at least if there is some possibility for userspace to sneak
> >> in and do a getresources ioctl between the first and second client.
> >> That might be easy enough to solve by adding some event for userspace
> >> to get notified that it should getresources again.  The unregister is
> >> what I worry about more.
> >>
> >> In general drm isn't set up to well for drivers that are a collection
> >> of sub-devices.  It is probably worth trying to improve this, although
> >> I am still a bit skittish about the edge cases, like what happens when
> >> you unload a sub-device mid-modeset.  The issue comes up again for
> >> common panel/display framework.
> >>
> >> But for now you might just want to do something to ensure that all the
> >> sub-devices are loaded/unloaded together as a whole.
> >
> > The way that the above is supposed to work is that the DRM relevant
> > host1x clients are kept in a separate list and only if all of them have
> > successfully been probed is the DRM portion initialized. Upon
> > unregistration, as soon as the first of these clients is unregistered,
> > all of the DRM stuff is torn down.
>=20
> ahh, ok, I guess if DRM is torn down on first unregister, then you
> shouldn't be hitting issues.  I wasn't sure if the intention was to be
> able to load/unload clients independently (such as building them as
> separate modules eventually)

No, this is all supposed to stay in one driver for now. We may want to
split off the host1x code into a separate driver because eventually it
will have to be accessed by V4L2 drivers as well, so drivers/gpu/drm
isn't the optimal place for it. However the basic requirement to have
all DRM related components register or unregister at once will stay
until the DRM core can handle dynamic registration better.

Thierry

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQnW+mAAoJEN0jrNd/PrOhLpsP+gNH/4FrgiddGNzP/f6xCnFS
Z+em29GaYFbHVRmZU918Pr2XL8fuktz7rLql6MYhMPxxiYGpkKs2XuKdf7E/zqdy
ltVORzP+MBYfTGao+EL63v/TI1sn0iROmAjKboU6UfncWYW2+WNyRDUdTQsOK4Bs
KsI6YUkpamaa6UXmLx8c9Bzc1LqDkHbScJUO0HFMz/yCAqgb/gKPBsO7AG/0qYgX
eEJj9w7Z83a5kwNJshMY2wo3CIURFz+qlUFALLfgB6uDY0Or40yEMWiRKBDAbEGn
DxIX7GL3bSwV2UIAk0sUgDdyuUTlhmpNamE+hhEJeuo1WFCmRZD9PtqibMI0Xj4g
cM0LeSHKNCzuOWLN3O2S49gJ9+/ijGvLdevq8TeTrlyUNuooCYeAX3xeS7d7L4Y8
e4msq/7JdlMlORca/2uOf+yydPGk5mGkiMjBruZ0F1nPLRwqD1Q5Wl7ZbiJxSlRU
4ZJHYuIgTOEpnmeSAOcDnxs7aYhEWH4i5bCrdimF3Asm4a42CpABWbmX/87vRVyY
OUO9BbYNBx2Qp9rVLYwD08ZddIuQByyOqG9dmSO2Q1Ryutt95aytLz7Fx7QROcqQ
Kvio7hthsp7neXNWo76mPbMjs1VdxJXckc4Vz42Wxkq42xcV/hPYNxmIIf3/IvBo
CD4EZ0DC4FkYMuDuH8cF
=UBU0
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
